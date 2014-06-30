//
//  LookReserveViewController.h
//  Food
//
//  Created by sundaoran on 14-5-20.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookReserveViewController : UIViewController<navigationBarViewDeleGete,UIAlertViewDelegate>


//设置预定详情
-(void)setReserve:(NSDictionary *)Info;

@end
