//
//  VipCardPassWordViewController.m
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipCardPassWordViewController.h"

@interface VipCardPassWordViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfCardNum;
    UITextField         *_tfCardNumToo;
    NSMutableDictionary           *_cardDict;
    BOOL                 setPassWord;//是否设置了支付密码，如果没有设置，不让返回
    CVLocalizationSetting   *langSetting;
}

@end

@implementation VipCardPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//第一次绑定会员卡时需要提交的信息
-(void)setVipCardDictFirst:(NSMutableDictionary *)carddict
{
    _cardDict=[[NSMutableDictionary alloc]initWithDictionary:carddict];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Add the vip card"]];
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
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Pay the password"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _tfCardNum =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfCardNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfCardNum.borderStyle=UITextBorderStyleNone;
    _tfCardNum.secureTextEntry=YES;
    [_tfCardNum becomeFirstResponder];
    _tfCardNum.delegate=self;
    _tfCardNum.font=[UIFont systemFontOfSize:14];
    _tfCardNum.placeholder=[langSetting localizedString:@"Enter the password for payment"];
    [messageView addSubview:_tfCardNum];
    
    
    UIView *messageViewToo=[[UIView alloc]initWithFrame:CGRectMake(10, messageView.frame.origin.y+messageView.frame.size.height+20, ScreenWidth-20, 60)];
    messageViewToo.backgroundColor=[UIColor whiteColor];
    messageViewToo.layer.borderColor=selfborderColor.CGColor;
    messageViewToo.layer.borderWidth=0.5;
    messageViewToo.layer.cornerRadius=5;
    [_backGround addSubview:messageViewToo];
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_card.png"]];
    [messageViewToo addSubview:imageViewLeft];
    
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Password confirmation"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageViewToo addSubview:lblLeft];
    
    _tfCardNumToo =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfCardNumToo.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfCardNumToo.borderStyle=UITextBorderStyleNone;
    _tfCardNumToo.secureTextEntry=YES;
    [_tfCardNumToo becomeFirstResponder];
    _tfCardNumToo.delegate=self;
    _tfCardNumToo.font=[UIFont systemFontOfSize:14];
    _tfCardNumToo.placeholder=[langSetting localizedString:@"Please enter payment password again"];
    [messageViewToo addSubview:_tfCardNumToo];
    
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, messageViewToo.frame.origin.y+messageViewToo.frame.size.height+15, SUPERVIEWWIDTH-20, 30);
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
    
    UIControl *control=[[UIControl alloc]initWithFrame:_backGround.bounds];
    [control addTarget:self action:@selector(controllClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:control];
    [_backGround sendSubviewToBack:control];
    
}

-(void)controllClick
{
    [_tfCardNum resignFirstResponder];
    [_tfCardNumToo resignFirstResponder];
}



-(void)navigationBarViewbackClick
{
//    if(setPassWord)
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
////        请设置支付密码
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Please set the payment password"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
//        [alert show];
//    }
}

-(void)changeButtonClick:(UIButton *)button
{
    [self controllClick];
    if([_tfCardNum.text length]==0)
    {
//        请输入支付密码
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Enter the password for payment"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            [alert show];
        });
        
    }
    else if (![_tfCardNum.text isEqualToString:_tfCardNumToo.text])
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[NSString stringWithFormat:@"%@",@"两次输入的密码不相同，请确认重新输入"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            [alert show];
        });
        
    }
    else
    {
//        支付密码一经确定将不可修改\n是否确定支付密码，或者取消重新设定
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[NSString stringWithFormat:@"支付密码一经确定将不可修改\n是否确定支付密码，或者取消重新设定"] delegate:self cancelButtonTitle:[langSetting localizedString:@"Reset"] otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            //,[langSetting localizedString:@"Pay the password will not change after confirmation whether \n determine pay password, or cancel to reset"]
            [alert show];
        });
        
    }

    
}

#pragma mark -alertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(updateCardPayPass) toTarget:self withObject:nil];
    }
    
}

//首次绑定会员卡设置支付密码
-(void)updateCardPayPass
{

    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
//        [info setObject:_cardNum forKey:@"cardNum"];
        [_cardDict setObject:_tfCardNum.text forKey:@"payPass"];
        NSDictionary *dict=[dp updateCardPayPass:_cardDict];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            bs_dispatch_sync_on_main_thread(^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getBindCardMessage" object:nil];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                setPassWord=YES;
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
    if(textField==_tfCardNum || textField==_tfCardNumToo)
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
