//
//  VipManageViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipManageViewController.h"
#import "VipPersonMessageViewController.h"

@interface VipManageViewController ()

@end

@implementation VipManageViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfCardNum;
    CVLocalizationSetting   *langSetting;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
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
    //    会员卡号
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Number"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _tfCardNum =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfCardNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfCardNum.borderStyle=UITextBorderStyleNone;
    [_tfCardNum becomeFirstResponder];
    _tfCardNum.font=[UIFont systemFontOfSize:14];
//    请输入卡号
    _tfCardNum.placeholder=[langSetting localizedString:@"Please enter the card number"];
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

//触发键盘隐藏事件
-(void)controlClick
{
    [_tfCardNum resignFirstResponder];
}



-(void)changeButtonClick:(UIButton *)button
{
    if([_tfCardNum.text length]!=0)
    {
        NSMutableDictionary *infodict=[[NSMutableDictionary alloc]init];
        [infodict setObject:_tfCardNum.text forKey:@"cardNum"];
         [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(queryCardMessage:) toTarget:self withObject:infodict];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"You haven't input the card number"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            [alert show];
        });
       
    }
}

//获取会员卡信息
-(void)queryCardMessage:(NSMutableDictionary *)infodict
{
    @autoreleasepool {
        DataProvider *dp=[DataProvider sharedInstance];
        dp.cardType=@"";
        NSDictionary *dict=[dp queryCardMessage:infodict];
        
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            NSDictionary *dictValue=[[dict objectForKey:@"Message"]firstObject];
            dp.cardType = [dictValue objectForKey:@"typ"];
            if([[dictValue objectForKey:@"appbind"]isEqualToString:@"Y"])
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"卡号为%@\n的会员卡已绑定",[dictValue objectForKey:@"cardNo"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                });

            }
            else
            {
                bs_dispatch_sync_on_main_thread(^{
                    
                    VipPersonMessageViewController *vipperson=[[VipPersonMessageViewController alloc]init];
                    [vipperson setVipCardNum:dictValue];
                    [self.navigationController pushViewController:vipperson animated:YES];
                });
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
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

@end
