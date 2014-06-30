//
//  VipPersonMessageViewController.h
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"

@interface VipPersonMessageViewController : UIViewController<navigationBarViewDeleGete,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

-(void)setVipCardNum:(NSDictionary *)cardNum;
@end
