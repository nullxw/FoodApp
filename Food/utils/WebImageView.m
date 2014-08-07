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

- (void)setImageURL:(NSString *)url andImageBoundName:(NSString *)imageName{
    //同步请求
//    [self synchronous:url];
    
    //异步请求
    NSString *strurl=[NSString stringWithFormat:@"%@",url];
//        NSArray *array=[strurl componentsSeparatedByString:@"#"];
//    if([[array lastObject]isEqualToString:@"ads"])
//    {
//        strurl=[array firstObject];
//    }
    _url=[NSString stringWithFormat:@"%@",strurl];
    [self aSynchronous2:strurl andImageName:imageName];
}


-(void)aSynchronous2:(NSString *)url andImageName:(NSString *)imageName
{
    NSLog(@"======>>网络");
    WebImageView *__block imageSelf=self;

    NSMutableURLRequest *requestAft = [[NSMutableURLRequest alloc] init];
    [requestAft setURL:[NSURL URLWithString:url]];
    [requestAft setTimeoutInterval:10.0f];
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestAft];
    //设置下载完成调用的block
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){
// URL: http://www.quanjude.com.cn/upload/app/4f9118a1619d40139c1be271aa608447.jpg, headers: (null)
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
        
        [imageSelf setImage:[UIImage imageWithData:data]];
        
    }failure:^(AFHTTPRequestOperation* operation, NSError* error){
        [imageSelf setImage:[UIImage imageNamed:imageName]];
        NSLog(@"下载失败%@",error);
    }];
    //开始下载
    [self.operation start];
}
-(void)cancelRequest
{
//    [self.operation cancel];
}

@end
