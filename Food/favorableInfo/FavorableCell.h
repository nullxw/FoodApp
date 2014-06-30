//
//  FavorableCell.h
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"

@interface FavorableCell : UITableViewCell{
//    WebImageView *imgTop;
    UILabel *lblName;
    UIWebView *web;
}

@property (nonatomic,retain) NSMutableDictionary *dicInfo;
@property (nonatomic,strong) WebImageView *imgTop;
@end
