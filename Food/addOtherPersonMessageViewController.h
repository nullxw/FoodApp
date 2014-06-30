//
//  VipCardPassWordViewController.h
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipMessageClass.h"

@interface addOtherPersonMessageViewController : UIViewController<navigationBarViewDeleGete>


-(void)setVipMessage:(VipMessageClass *)vipMessage;

-(void)setPassWd:(NSString *)passWd;

@end
