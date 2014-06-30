//
//  registerViewController.h
//  Food
//
//  Created by sundaoran on 14-3-27.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "typeSelectViewViewController.h"

@interface registerViewController : UIViewController<typeSelectViewViewControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    BOOL _isChange;//是否为修改账号
}

@property(nonatomic)BOOL isChange;

@end
