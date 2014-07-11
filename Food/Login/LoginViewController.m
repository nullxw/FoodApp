//
//  LoginViewController.m
//  Food
//
//  Created by dcw on 14-3-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "LoginViewController.h"
#import "DataProvider.h"
#import "registerViewController.h"
#import "VipManageViewController.h"
#import "MenuViewController.h"
#import "NewMenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIView                  *v;
    NSString                *AuthouNum;

    CGFloat                 VIEWHRIGHT;
     CVLocalizationSetting *langSetting;
    BOOL                    _isAuthor;//是否已经点击获取验证码
    
    NSString                *_authorPhoneNum;
    
    int                 minCount;//获取验证码倒计时
    NSTimer *minCountTimer;//计时器

}

@synthesize isChange=_isChange;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title=@"获取验证码";
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [minCountTimer invalidate];
    [DataProvider sharedInstance].isClearColor=NO;//导航条有色;
    _authorPhoneNum=nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    langSetting=[CVLocalizationSetting sharedInstance];
    
    NSString *imageName;
    NSLog(@"%f",ScreenHeight);
    if(ScreenHeight==568)
    {
        imageName=@"Author_main3.jpg";
    }
    else
    {
        imageName=@"Author_main.jpg";
    }
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame=self.view.bounds;
    [self.view addSubview:imageView];
	
    v = [[UIView alloc] init];
    v.frame = CGRectMake(10, 180,SUPERVIEWWIDTH-20, 160);
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UILabel *lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, 30)];
    lbltitle.text=[langSetting localizedString:@"Binding mobile phone"];//@"绑定手机";
    lbltitle.textAlignment=NSTextAlignmentCenter;
    lbltitle.font=[UIFont systemFontOfSize:17];
    lbltitle.backgroundColor=selfbackgroundColor;
    lbltitle.textColor=[UIColor whiteColor];
    [v addSubview:lbltitle];
    
    lblPhone = [[UILabel alloc] init];
    lblPhone.frame = CGRectMake(10, 40, 70, 30);
    lblPhone.text = [langSetting localizedString:@"Phone number"];//@"手机号:";
    lblPhone.textColor=selfbackgroundColor;
    lblPhone.backgroundColor = [UIColor clearColor];
    [v addSubview:lblPhone];
    
    lblYanZ = [[UILabel alloc] init];
    lblYanZ.frame = CGRectMake(10, 80, 70, 30);
    lblYanZ.text =[langSetting localizedString:@"Verification code"];// @"验证码:";
    lblYanZ.textColor=selfbackgroundColor;
    lblYanZ.backgroundColor = [UIColor clearColor];
    [v addSubview:lblYanZ];
    
    
//    extern NSString *CTSettingCopyMyPhoneNumber();
//    int phone1 = (int)CTSettingCopyMyPhoneNumber();
//    NSString *p = [NSString stringWithFormat:@"%d",phone1];
    tfPhone = [[UITextField alloc] init];
    tfPhone.frame = CGRectMake(70, 40, 170, 30);
    tfPhone.placeholder = [langSetting localizedString:@"Please enter the phone number"];//@"请输入手机号";
    tfPhone.borderStyle=UITextBorderStyleRoundedRect;
    tfPhone.keyboardType = UIKeyboardTypePhonePad;
    tfPhone.delegate=self;
    tfPhone.clearButtonMode=UITextFieldViewModeWhileEditing;
//    tfPhone.text = CTSettingCopyMyPhoneNumber();
    tfPhone.delegate=self;
    [v addSubview:tfPhone];
    
    tfYanZ = [[UITextField alloc] init];
    tfYanZ.frame = CGRectMake(70, 80, 95, 30);
    tfYanZ.placeholder = [langSetting localizedString:@"Verification code"];//@"验证码";
    tfYanZ.borderStyle=UITextBorderStyleRoundedRect;
    tfYanZ.keyboardType = UIKeyboardTypePhonePad;
    tfYanZ.clearButtonMode=UITextFieldViewModeWhileEditing;
    tfYanZ.delegate = self;
    [v addSubview:tfYanZ];
    
    butHuoqu = [UIButton buttonWithType:UIButtonTypeCustom];
    butHuoqu.frame = CGRectMake(180, 80, 110, 30);
    butHuoqu.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [butHuoqu setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
    [butHuoqu setTitle:[langSetting localizedString:@"Get verification code"] forState:UIControlStateNormal];
    [butHuoqu setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
    [butHuoqu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [butHuoqu setBackgroundColor:[UIColor redColor]];
    [butHuoqu addTarget:self action:@selector(AuthCode) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:butHuoqu];
    
    butSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    butSubmit.frame = CGRectMake(10, 120, v.frame.size.width-20, 30);
    butSubmit.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [butSubmit setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [butSubmit setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    [butSubmit setTitle:[langSetting localizedString:@"Submit"] forState:UIControlStateNormal];
    butSubmit.layer.cornerRadius=3;
    [butSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    butSubmit.titleLabel.font=[UIFont systemFontOfSize:17];
    [butSubmit addTarget:self action:@selector(SubmitClick) forControlEvents:UIControlEventTouchUpInside];
    //    [butHuoqu setBackgroundColor:[UIColor redColor]];
    [v addSubview:butSubmit];
    
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHRIGHT=64.0;
    }
    else
    {
        VIEWHRIGHT=44.0;
    }
    
    if(_isChange)
    {
        navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:nil];
//        [langSetting localizedString:@"Modify the binding mobile phone"]
        nvc.delegate=self;
        [self.view addSubview:nvc];
    }
    
    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view sendSubviewToBack:control];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoaryShow) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoaryHidde) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)controlClick
{
    [tfPhone resignFirstResponder];
    [tfYanZ resignFirstResponder];
}

-(void)keyBoaryShow
{
    [UIView animateWithDuration:0.2 animations:^{
     v.frame = CGRectMake(10, 75, SUPERVIEWWIDTH-20, 160);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoaryHidde
{
    [UIView animateWithDuration:0.2 animations:^{
        v.frame = CGRectMake(10, 180,SUPERVIEWWIDTH-20, 160);
    } completion:^(BOOL finished) {
        
    }];
   
}

-(void)AuthCode{
    if([tfPhone.text length]!=11)
    {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please correct phone number"]];
    }
    else
    {
        if(!_isAuthor)
        {
            _isAuthor=YES;
            _authorPhoneNum=tfPhone.text;
            minCountTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(canGetAuthor) userInfo:nil repeats:YES];
            [butHuoqu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [butHuoqu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [butHuoqu setBackgroundColor:[UIColor grayColor]];
            [NSThread detachNewThreadSelector:@selector(AuthCode1) toTarget:self withObject:nil];
        }
    }
}


-(void)SubmitClick
{

//    regis.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:regis animated:YES completion:^{
//        
//    }];
//    [self controlClick];
    NSString *title=@"";
    if([tfPhone.text length]!=11)
    {
        title=[langSetting localizedString:@"Please correct phone number"];
    }
    else if([tfYanZ.text length]!=6)
    {
        title=[langSetting localizedString:@"Please enter the verification code"];
    }
    else if(_authorPhoneNum==nil || ![_authorPhoneNum isEqualToString:tfPhone.text] )
    {
         title=@"手机号码不匹配";
    }
    else
    {
        if(!AuthouNum)
        {
            title=[langSetting localizedString:@"Haven't get verification code"];
            
        }
        else if([AuthouNum isEqualToString:tfYanZ.text])
        {
            [SVProgressHUD showWithStatus:nil];
            [NSThread detachNewThreadSelector:@selector(getUserPersonMessage) toTarget:self withObject:nil];
           
        }
        else
        {
            title=[langSetting localizedString:@"Verification code is not correct"];
        }
    }
    [title isEqualToString:@""]?:[SVProgressHUD showErrorWithStatus:title];;
}

-(void)AuthCode1{
    @autoreleasepool {
      
            DataProvider *dp = [[DataProvider alloc] init];
            NSDictionary *dic = [dp getPhoneAuthCode:tfPhone.text];
            if ([[dic objectForKey:@"Result"] boolValue]) {
//                111111
                AuthouNum=[dic objectForKey:@"Message"];
//                AuthouNum=@"111111";
            }else
            {
                _authorPhoneNum=nil;
                [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
                minCount=60;
                [self canGetAuthor];
            }
            
        }
}

-(void)canGetAuthor
{
    if(minCount <60)
    {
        minCount+=1;
        [butHuoqu setTitle:[NSString stringWithFormat:@"%d秒重新获取",60-minCount] forState:UIControlStateNormal];
    }
    else
    {
        minCount=0;
        [minCountTimer invalidate];
    [butHuoqu setTitle:[langSetting localizedString:@"Get verification code"] forState:UIControlStateNormal];
    [butHuoqu setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
    [butHuoqu setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
    _isAuthor=NO;
    }
}

//注册成功后，查询该手机下是否含有用户信息
-(void)getUserPersonMessage
{
    @autoreleasepool
    {
        NSMutableDictionary  *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:tfPhone.text forKey:@"mobtel"];
        NSDictionary *dict=[[DataProvider sharedInstance]getUserPersonMessage:Info];
        if(dict)
        {
            if([[dict objectForKey:@"Result"]boolValue])
            {
                if([[dict objectForKey:@"isNULL"]boolValue])
                {
                    bs_dispatch_sync_on_main_thread(^{
                        [SVProgressHUD dismiss];
                        registerViewController *regis=[[registerViewController alloc]init];
                        if(_isChange)//判断是否为修改账号
                        {
                            regis.isChange=YES;
                        }
                        else
                        {
                            regis.isChange=NO;
                        }
                        [self.navigationController pushViewController:regis animated:YES];
                    });
                }
                else
                {
                    bs_dispatch_sync_on_main_thread(^{
                        [SVProgressHUD dismiss];
                        if(_isChange)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
//                            MenuViewController *menu=[[MenuViewController alloc]init];
                            NewMenuViewController *menu=[[NewMenuViewController alloc]init];
                            
                            //                    [self.navigationController pushViewController:menu animated:YES];
                            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:menu];
                            nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                            [self presentViewController:nvc animated:YES completion:^{
                                
                            }];
                        }
                    });
                }
                //获取字典中的用户名，证明该手机已经注册用户
                [[NSUserDefaults standardUserDefaults]setObject:[[[[[dict objectForKey:@"Message"]objectForKey:@"listTele" ] objectForKey:@"listCard"]objectForKey:@"com.choice.webService.domain.Card"]objectForKey:@"name" ] forKey:@"userName"];//用户姓名
                [[NSUserDefaults standardUserDefaults]setObject:[[[[[dict objectForKey:@"Message"]objectForKey:@"listTele" ] objectForKey:@"listCard"]objectForKey:@"com.choice.webService.domain.Card"]objectForKey:@"cardId" ] forKey:@"userId"];//用户的唯一标识
                [[NSUserDefaults standardUserDefaults]setObject:tfPhone.text forKey:@"userPhone"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
            }
        }
        else
        {
           [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if(textField !=tfPhone)
        {
            return YES;
        }
        else
        {
            if((textField==tfPhone && [tfPhone.text length]<=0 &&[string isEqualToString:@"0"]) || [tfPhone.text length]>10)
            {
                return NO;
            }
            
            else
            {
                NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
                
                NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
                
                BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
                
                if (myStringMatchesRegEx)
                    
                    return YES;
                
                else
                    
                    return NO;
            }

        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)navigationBarViewbackClick
{
   bs_dispatch_sync_on_main_thread(^{
       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"If we give up change binding mobile phone number"] delegate:self cancelButtonTitle:[langSetting localizedString:@"No"] otherButtonTitles:[langSetting localizedString:@"Sure"], nil];
       [alert show];
   });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
