//
//  addOtherPassVertryViewController.m
//  Food
//
//  Created by sundaoran on 14-5-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "addOtherPassVertryViewController.h"
#import "addOtherPersonMessageViewController.h"

@interface addOtherPassVertryViewController ()

@end

@implementation addOtherPassVertryViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfPassNum;
    CVLocalizationSetting    *langSetting;
    VipMessageClass            *_vipMessage;//会员卡使用者姓名，一个账号只拥有一个名字

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setVipMessage:(VipMessageClass *)vipMessage
{
    _vipMessage=vipMessage;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    langSetting=[CVLocalizationSetting sharedInstance];
    // Do any additional setup after loading the view.
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
    
    //密码验证
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Password authentication"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
    
    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 60)];
    messageView.backgroundColor=[UIColor whiteColor];
    messageView.layer.borderColor=selfborderColor.CGColor;
    messageView.layer.borderWidth=0.5;
    messageView.layer.cornerRadius=5;
    [_backGround addSubview:messageView];
    
    UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_card.png"]];
    [messageView addSubview:imageViewLeft];
    
    
    UILabel  *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
//    支付密码
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Pay the password"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _tfPassNum =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfPassNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfPassNum.borderStyle=UITextBorderStyleNone;
    _tfPassNum.secureTextEntry=YES;
    _tfPassNum.delegate=self;
    [_tfPassNum becomeFirstResponder];
    _tfPassNum.font=[UIFont systemFontOfSize:14];
//    请输入支付密码
    _tfPassNum.placeholder=[langSetting localizedString:@"Enter the password for payment"];
    [messageView addSubview:_tfPassNum];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, messageView.frame.origin.y+messageView.frame.size.height+15, SUPERVIEWWIDTH-20, 30);
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
    [_tfPassNum resignFirstResponder];
}
-(void)changeButtonClick:(UIButton *)button
{
    [self controlClick];
    if([_tfPassNum.text length]==0)
    {
//        请输入会员卡支付密码
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please enter the card payment password"]];
    }
    else
    {
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(checkPassWd) toTarget:self withObject:nil];
    }

    
}
-(void)checkPassWd
{
    @autoreleasepool {
        if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
        {
            //@"请先绑定手机号码"
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
        }
        else
        {
            NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
            [Info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"] forKey:@"mobtel"];
            [Info setObject:_tfPassNum.text forKey:@"passWd"];
            NSDictionary *dict=[[DataProvider sharedInstance] checkPassWd:Info];
            if([[dict objectForKey:@"Result"]boolValue])
            {
                [SVProgressHUD dismiss];
                bs_dispatch_sync_on_main_thread(^{
                    addOtherPersonMessageViewController *add=[[addOtherPersonMessageViewController alloc]init];
                    [add setVipMessage:_vipMessage];
                    [add setPassWd:_tfPassNum.text];
                    [self.navigationController pushViewController:add animated:YES];
                });
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if(textField==_tfPassNum)
    {
        if([textField.text length]>5)
        {
            [SVProgressHUD showErrorWithStatus:@"密码长度最长为六位字符数字或者字符"];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
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
