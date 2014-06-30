//
//  VipAuthorViewController.h
//  Food
//
//  Created by sundaoran on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"

@interface VipAuthorViewController : UIViewController<navigationBarViewDeleGete>


//第一次绑定会元填写的个人信息
-(void)setPersonInfo:(NSMutableDictionary *)personInfo;


//改变会员卡密码是需要提交的信息
-(void)setChangePassWordInfo:(NSMutableDictionary *)Info;

@end
