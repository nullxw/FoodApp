//
//  WebImageView.m
//  ASIHttpDemo
//
//  Created by wei.chen on 13-1-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WebImageView.h"


@implementation WebImageView
{
    NSString     *_url;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        strType = @"1";
    }
    return self;
}

- (void)setImageURL:(NSURL *)url{
    //同步请求
//    [self synchronous:url];
    
    //异步请求
    NSString *strurl=[NSString stringWithFormat:@"%@",url];
        NSArray *array=[strurl componentsSeparatedByString:@"#"];
    if([[array lastObject]isEqualToString:@"ads"])
    {
        strurl=[array firstObject];
    }
    _url=[NSString stringWithFormat:@"%@",strurl];
    [self aSynchronous2:strurl];
}


-(void)aSynchronous2:(NSString *)url
{
    WebImageView *__block imageSelf=self;
    NSURLRequest* requestAft = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestAft];
    //设置下载完成调用的block
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){

        //NSLog(@"%@",operation.responseData)
        NSData *data=operation.responseData;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *localPath = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *DirectoryPath=[localPath stringByAppendingString:@"/ads"];
        [fileManager createDirectoryAtPath:DirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
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
        
        [imageSelf setImage:[UIImage imageWithData:data]];
        
    }failure:^(AFHTTPRequestOperation* operation, NSError* error){
        NSLog( @"Server timeout!" );
        
    }];
    //开始下载
    [self.operation start];
}
-(void)cancelRequest
{
    [self.operation pause];
}

@end
