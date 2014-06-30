//
//  navigationBarView.h
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProvider.h"

#define SUPERVIEWWIDTH  self.view.frame.size.width
#define SUPERVIEWHEIGHT self.view.frame.size.height
#define TITIEIMAGEVIEW  @"App首页jpg"

@protocol navigationBarViewDeleGete <NSObject>

-(void)navigationBarViewbackClick;

@end

@interface navigationBarView : UIView
{
 
    __weak id<navigationBarViewDeleGete>_delegate;
     BOOL _isChange;
}

@property(nonatomic)BOOL isChange;
@property(nonatomic,weak)__weak id<navigationBarViewDeleGete>delegate;


- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)rightTitle;


@end
