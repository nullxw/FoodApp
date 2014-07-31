//
//  VipAuthorViewController.m
//  Food
//
//  Created by sundaoran on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipAuthorViewController.h"
#import "VipCardPassWordViewController.h"
#import "addOtherPasswordViewController.h"

@interface VipAuthorViewController ()
{
    UIView                  *_backGround;
    CGFloat                 VIEWHRIGHT;
    UITextField             *_tfAuthorNum;
    NSString                *AuthouNum;
    UILabel                 *lblMessage;
    NSMutableDictionary     *_personInfo;
    NSMutableDictionary     *_changePassInfo;
    BOOL                    ischangePass;
    CVLocalizationSetting   *langSetting;
    
    UIButton   *getAuthor;
    BOOL        isGetAuthor;
    int          minCount;//60秒倒计时
    NSTimer *minCountTimer;//计时器
}

@end

@implementation VipAuthorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [minCountTimer invalidate];
}

//第一次绑定会元填写的个人信息
-(void)setPersonInfo:(NSMutableDictionary *)personInfo
{
    _personInfo=[[NSMutableDictionary alloc]initWithDictionary:personInfo];
    ischangePass=NO;
}


//改变会员卡密码是需要提交的信息
-(void)setChangePassWordInfo:(NSMutableDictionary *)Info
{
    _changePassInfo=[[NSMutableDictionary alloc]initWithDictionary:Info];
    ischangePass=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    minCount=0;
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHRIGHT=64.0;
    }
    else
    {
        VIEWHRIGHT=44.0;
    }
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];

    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Add the vip card"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 60)];
    messageView.backgroundColor=[UIColor whiteColor];
    messageView.layer.borderColor=selfborderColor.CGColor;
    messageView.layer.borderWidth=0.5;
    messageView.layer.cornerRadius=5;
    [_backGround addSubview:messageView];
    
    UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_cardphone.png"]];
    [messageView addSubview:imageViewLeft];
    
    
    UILabel  *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,80, 60);
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Verification code"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _tfAuthorNum =[[UITextField alloc]initWithFrame:CGRectMake(110, 15, 100, 30)];
    _tfAuthorNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfAuthorNum.borderStyle=UITextBorderStyleNone;
    [_tfAuthorNum becomeFirstResponder];
    _tfAuthorNum.keyboardType=UIKeyboardTypePhonePad;
    _tfAuthorNum.font=[UIFont systemFontOfSize:14];
    _tfAuthorNum.placeholder=@"输入验证码";
    [messageView addSubview:_tfAuthorNum];
    
    getAuthor=[UIButton buttonWithType:UIButtonTypeCustom];
    getAuthor.frame=CGRectMake(210, 15, messageView.frame.size.width-220, 30);

    [getAuthor setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
    [getAuthor setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
    [getAuthor setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAuthor.titleLabel.font=[UIFont systemFontOfSize:12];
    [getAuthor addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [getAuthor setTag:101];
    [getAuthor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageView addSubview:getAuthor];
    
    
    NSString *phone;
    if(ischangePass)
    {
        phone=[NSString stringWithFormat:@"%@",[_changePassInfo objectForKey:@"phone"]];
    }
    else
    {
        phone=[NSString stringWithFormat:@"%@",[_personInfo objectForKey:@"tele"]];
    }
    lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(30, messageView.frame.origin.y+messageView.frame.size.height, messageView.frame.size.width-60, 40)];
    lblMessage.numberOfLines=2;
    lblMessage.lineBreakMode=NSLineBreakByWordWrapping;
    lblMessage.text=[NSString stringWithFormat:@"绑定会员卡需要短信确认，验证码已经发送至你的手机%@......%@,请按照提示操作",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange([phone length]-4, 4)]];
    //[langSetting localizedString:@"Binding membership card need SMS confirmation, verification code has been sent to your mobile phone %@......%@, please according to clew operation"]
    lblMessage.font=[UIFont systemFontOfSize:10];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, lblMessage.frame.origin.y+lblMessage.frame.size.height+15, SUPERVIEWWIDTH-20, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    nextButton.tag=104;
    [nextButton  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Next step"]];
    netlbl.textAlignment=NSTextAlignmentCenter;
    netlbl.backgroundColor=[UIColor clearColor];
    netlbl.font=[UIFont systemFontOfSize:13];
    [netlbl setTextColor:[UIColor whiteColor]];
    [nextButton addSubview:netlbl];
    [_backGround addSubview:nextButton];

}

-(void)controlClick
{
    [_tfAuthorNum resignFirstResponder];
}


-(void)changeButtonClick:(UIButton *)button
{
    [self controlClick];
    if(button.tag==101)
    {
        if(!isGetAuthor)
        {
            //如果以获取验证码，在获取失败或者一分钟之内不可重复获取
            [_backGround addSubview:lblMessage];
            isGetAuthor=YES;
            [getAuthor setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [getAuthor setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [getAuthor setBackgroundColor:[UIColor grayColor]];
            [NSThread detachNewThreadSelector:@selector(getAuthorNum) toTarget:self withObject:nil];
            minCountTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeGetAuthorButton) userInfo:nil repeats:YES];
        }
    }
    else if (button.tag==104)
    {
        if([_tfAuthorNum.text isEqualToString:AuthouNum])
        {
            if(ischangePass)
            {
                 [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
                [NSThread detachNewThreadSelector:@selector(changePassword:) toTarget:self withObject:_changePassInfo];
                return;
            }
            else
            {
                if([DataProvider sharedInstance].isFirst)
                {
                     //首次绑定会员卡
                    VipCardPassWordViewController *vipCardView=[[VipCardPassWordViewController alloc]init];
                    [vipCardView setVipCardDictFirst:_personInfo];
                    [self.navigationController pushViewController:vipCardView animated:YES];
                }
                else
                {
                    //                第二次绑定会员卡
                    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"The personal information submitted..."] maskType:SVProgressHUDMaskTypeBlack];
                    [NSThread detachNewThreadSelector:@selector(bindingVIPCard:) toTarget:self withObject:_personInfo];
                }
            }
        }
        else
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Verification code error"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                [alert show];
            });
            
        }
    }
}

// 第二次绑定会员卡
-(void)bindingVIPCard:(NSMutableDictionary *)info
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        [info setObject:[NSNumber numberWithBool:NO] forKey:@"isFirst"];
        NSDictionary *dict=[dp bindingVIPCard:info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            //            从多线程回到主线程，并跳转到密码设置界面
            bs_dispatch_sync_on_main_thread(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getBindCardMessage" object:nil];
                [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:[self.navigationController.childViewControllers count]-5] animated:YES];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
    }
}



//修改会员啦支付密码
-(void)changePassword:(NSMutableDictionary *)info
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp replacePassWord:info];
        if ([[dict objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            bs_dispatch_sync_on_main_thread(^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}


//获取验证码
-(void)getAuthorNum
{
    @autoreleasepool {
        
        DataProvider *dp = [[DataProvider alloc] init];
        NSString *phoneNum;
        if(ischangePass)
        {
             phoneNum=[_changePassInfo objectForKey:@"phone"];
        }
        else
        {
             phoneNum=[_personInfo objectForKey:@"tele"];
        }
        NSDictionary *dic = [dp getPhoneAuthCode:phoneNum];
        if ([[dic objectForKey:@"Result"] boolValue])
        {
//            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            
//            111111
            AuthouNum=[dic objectForKey:@"Message"];
//             AuthouNum=@"111111";
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get verification code, please get it again"]];
            minCount=60;
            [self changeGetAuthorButton];
            
        }
    }
}


//获取验证码后开始倒计时，倒计时结束后可重新获取验证码
-(void)changeGetAuthorButton
{
    if(minCount<60)
    {
        minCount+=1;
        [getAuthor setTitle:[NSString stringWithFormat:@"%d秒重新获取",60-minCount] forState:UIControlStateNormal];
       
    }
    else
    {
        minCount=0;
         [minCountTimer invalidate];//关闭计时器
        [getAuthor setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
        [getAuthor setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
        [getAuthor setTitle:@"获取验证码" forState:UIControlStateNormal];
        isGetAuthor=NO;
    }
    
}



-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
