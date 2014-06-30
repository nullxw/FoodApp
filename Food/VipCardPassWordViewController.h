//
//  VipCardPassWordViewController.h
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "VipPersonMessageViewController.h"
@interface VipCardPassWordViewController : UIViewController<navigationBarViewDeleGete,UIAlertViewDelegate,UITextFieldDelegate>


-(void)setVipCardDictFirst:(NSMutableDictionary *)carddict;

@end
