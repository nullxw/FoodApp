//
//  LoginViewController.h
//  Food
//
//  Created by dcw on 14-3-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate,navigationBarViewDeleGete,UIAlertViewDelegate>{
    UILabel *lblPhone,*lblYanZ;
    UITextField *tfPhone,*tfYanZ;
    UIButton *butSubmit,*butHuoqu;
    
    BOOL    _isChange;//判断为更换绑定，还是注册绑定
}

@property(nonatomic)BOOL isChange;

@end
