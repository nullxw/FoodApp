//
//  WebImageView.h
//  ASIHttpDemo
//
//  Created by wei.chen on 13-1-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface WebImageView : UIImageView{
    NSMutableArray *aryRequest;
    NSString *strType;
}

- (void)setImageURL:(NSString *)url andImageBoundName:(NSString *)imageName;
-(void)cancelRequest;

@property(nonatomic,strong)AFHTTPRequestOperation* operation;
@end
