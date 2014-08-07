//
//  WebwebView.h
//  Food
//
//  Created by sundaoran on 14-6-10.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface WebwebView : UIWebView
{
    NSMutableArray *aryRequest;
    NSString *strType;

}

- (void)setImageURL:(NSString *)url;
-(void)cancelRequest;
@property(nonatomic,strong)AFHTTPRequestOperation* operation;

@end
