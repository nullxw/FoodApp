//
//  WebwebView.m
//  Food
//
//  Created by sundaoran on 14-6-10.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "WebwebView.h"


@implementation WebwebView
{
    NSString     *_url;
}

@synthesize request;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        strType = @"1";
    }
    return self;
}




- (void)setImageURL:(NSString *)url{
    //同步请求
    //    [self synchronous:url];
    NSString *strurl=[NSString stringWithFormat:@"%@",url];
//    NSArray *array=[strurl componentsSeparatedByString:@"#"];
//    if([[array lastObject]isEqualToString:@"ads"])
//    {
//        strurl=[NSURL URLWithString:[array firstObject]];
//    }
    _url=[NSString stringWithFormat:@"%@",strurl];
    //异步请求
    [self aSynchronous2:strurl];
}

-(void)aSynchronous2:(NSString *)url
{
    WebwebView *__block imageSelf=self;
    NSMutableURLRequest* requestAft = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
     [requestAft setTimeoutInterval:10.0f];
     self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestAft];
    //设置下载完成调用的block
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){
        
        //NSLog(@"%@",operation.responseData)
        NSData *data=operation.responseData;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *localPath = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *DirectoryPath=[localPath stringByAppendingString:@"/ads"];
        
        if(![fileManager fileExistsAtPath:DirectoryPath])
        {
            [fileManager createDirectoryAtPath:DirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *filePath;
        if([[[url componentsSeparatedByString:@"#"]lastObject]isEqualToString:@"ads"])
        {
            filePath=[localPath stringByAppendingString:[NSString stringWithFormat:@"/ads/%@.png",[DataProvider md5:[NSString stringWithFormat:@"%@",url]]]];
        }
        else
        {
            filePath=[localPath stringByAppendingString:[NSString stringWithFormat:@"/%@",[DataProvider md5:[NSString stringWithFormat:@"%@",url]]]];
        }
        if(![fileManager fileExistsAtPath:filePath])
        {
            BOOL flag= [fileManager createFileAtPath:filePath contents:data attributes:nil];
            if(flag)
            {
                NSLog(@"cacheSuccess");
                
            }
            else
            {
                NSLog(@"cacheFail");
            }
        }
        [imageSelf loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    }failure:^(AFHTTPRequestOperation* operation, NSError* error){
        NSLog( @"Server timeout!" );
    
    }];
    //开始下载
    [self.operation start];

}
-(void)cancelRequest
{
//    [self.operation cancel];
}

@end
