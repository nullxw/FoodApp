//
//  BookingViewController.h
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "typeSelectViewViewController.h"

@interface BookingViewController : UIViewController<navigationBarViewDeleGete,UIPickerViewDataSource,UIPickerViewDelegate,typeSelectViewViewControllerDelegate>

@end
