//
//  VipCardPassWordViewController.m
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "addOtherPersonMessageViewController.h"
#import "addOtherCardMessageViewController.h"
@interface addOtherPersonMessageViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfcardNum;
    UILabel             *_lblUserName;
    VipMessageClass            *_vipMessage;//会员卡使用者姓名，一个账号只拥有一个名字
    NSString                    *_passWd;
    
    CVLocalizationSetting    *langSetting;
}

@end

@implementation addOtherPersonMessageViewController

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
-(void)setPassWd:(NSString *)passWd
{
    _passWd=passWd;
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
    
//    添加会员卡
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
//    姓名
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Name"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _lblUserName =[[UILabel alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _lblUserName.text=_vipMessage.cardname;
    _lblUserName.textColor=[UIColor blackColor];
    _lblUserName.textAlignment=NSTextAlignmentLeft;
    _lblUserName.font=[UIFont systemFontOfSize:14];
    [messageView addSubview:_lblUserName];
    
    
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
//    卡号
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Number"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageViewToo addSubview:lblLeft];
    
    _tfcardNum =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfcardNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfcardNum.borderStyle=UITextBorderStyleNone;
    [_tfcardNum becomeFirstResponder];
    _tfcardNum.font=[UIFont systemFontOfSize:14];
    //请输入需要添加的会员卡号
    _tfcardNum.placeholder=[langSetting localizedString:@"Please enter the card number"];
    [messageViewToo addSubview:_tfcardNum];
    
    
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
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:control];
    [_backGround sendSubviewToBack:control];
    
}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)controlClick
{
    [_tfcardNum resignFirstResponder];
}
-(void)changeButtonClick:(UIButton *)button
{
    [self controlClick];
    if([_tfcardNum.text length]==0)
    {
//        你还未输入会员卡手机号码
         [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please enter the phone number"]];
    }
    else
    {
        NSMutableDictionary *infodict=[[NSMutableDictionary alloc]init];
        [infodict setObject:_tfcardNum.text forKey:@"cardNum"];
         [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(queryCardMessage:) toTarget:self withObject:infodict];
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
            NSMutableDictionary *dictValue=[[NSMutableDictionary alloc]initWithDictionary:[[dict objectForKey:@"Message"]firstObject]];
            dp.cardType = [dictValue objectForKey:@"typ"];
            if([[dictValue objectForKey:@"appbind"]isEqualToString:@"Y"])
            {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"卡号为%@\n的会员卡已绑定",[dictValue objectForKey:@"cardNo"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                bs_dispatch_sync_on_main_thread(^{
                    
                    addOtherCardMessageViewController *add=[[addOtherCardMessageViewController alloc]init];
                    [dictValue setObject:_vipMessage.cardname  forKey:@"name"];
                    [dictValue setObject:_vipMessage.cardId forKey:@"cardId"];
                    [dictValue   setObject:_passWd forKey:@"passWd"];
                    [add setVipCardInf:dictValue];
                    [self.navigationController pushViewController:add animated:YES];
                });
            }
            
            
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
