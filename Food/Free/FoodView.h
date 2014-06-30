//
//  FoodView.h
//  Food
//
//  Created by dcw on 14-4-30.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"

@interface FoodView : UIView{
    WebImageView *webImg;
    UIImageView  *imgclose;
    UILabel *lblName,*lblPrice,*lblInfro;
}

+ (FoodView *)FoodViewWithInfo:(NSDictionary *)info;
- (void)show;

@end
