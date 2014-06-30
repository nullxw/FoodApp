//
//  selectTableViewController.h
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "StoreMessage.h"

@interface selectTableViewController : UIViewController<navigationBarViewDeleGete,UIPickerViewDelegate,UIPickerViewDataSource>

//初始化复制选择的门店信息
-(id)initWithMessageDict:(StoreMessage *)storemessage;

@end
