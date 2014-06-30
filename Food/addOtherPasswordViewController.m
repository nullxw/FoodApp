//
//  VipAddotherViewController.m
//  Food
//
//  Created by sundaoran on 14-4-29.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "addOtherPasswordViewController.h"

@interface addOtherPasswordViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfCardNum;
    NSMutableDictionary *_info;
    CVLocalizationSetting   *langSetting;
}

@end

@implementation addOtherPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setVipCardInf:(NSMutableDictionary *)info
{
    _info=[[NSMutableDictionary alloc]initWithDictionary:info];
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
    
//    支付密码
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
    _tfCardNum.font=[UIFont systemFontOfSize:14];
//    请输入支付密码
    _tfCardNum.placeholder=[langSetting localizedString:@"Enter the password for payment"];
    [messageView addSubview:_tfCardNum];
    
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

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)controlClick
{
    [_tfCardNum resignFirstResponder];
}
-(void)changeButtonClick:(UIButton *)button
{
    [self controlClick];
    if([_tfCardNum.text length]==0)
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Please enter the card payment password"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            [alert show];
            });

    }
    else
    {
//        个人信息提交中...
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"The personal information submitted..."] maskType:SVProgressHUDMaskTypeBlack];
        [_info setObject:_tfCardNum.text forKey:@"password"];
        [NSThread detachNewThreadSelector:@selector(bindingVIPCard:) toTarget:self withObject:_info];
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
