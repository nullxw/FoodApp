//
//  VipCardPassWordViewController.m
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "addOtherCardMessageViewController.h"
#import "VipCheckSelectViewController.h"
#import "VipAuthorViewController.h"

@interface addOtherCardMessageViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfPhoneNum;
    UILabel             *_lblcardType;
    BOOL                isAgreeProtocol;//是否同意协议
    NSMutableDictionary *_info;
    CVLocalizationSetting *langSetting;
}

@end

@implementation addOtherCardMessageViewController

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
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_card.png"]];
    [messageView addSubview:imageViewLeft];
    
    
    UILabel  *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
//    卡类型
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Card type"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    _lblcardType =[[UILabel alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    [_lblcardType setText:[DataProvider sharedInstance].cardType];
    _lblcardType.textColor=[UIColor blackColor];
    _lblcardType.textAlignment=NSTextAlignmentLeft;
    _lblcardType.font=[UIFont systemFontOfSize:14];
    [messageView addSubview:_lblcardType];
    
    
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
//    手机号
    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Phone number"]]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageViewToo addSubview:lblLeft];
    
    _tfPhoneNum =[[UITextField alloc]initWithFrame:CGRectMake(100, 15, messageView.frame.size.width-110, 30)];
    _tfPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tfPhoneNum.borderStyle=UITextBorderStyleNone;
    _tfPhoneNum.keyboardType=UIKeyboardTypePhonePad;
    _tfPhoneNum.font=[UIFont systemFontOfSize:14];
    _tfPhoneNum.delegate=self;
    _tfPhoneNum.placeholder=[langSetting localizedString:@"Please enter the phone number"];
    [messageViewToo addSubview:_tfPhoneNum];
    
    
    UIView *Protocolview=[[UIView alloc]initWithFrame:CGRectMake(20, messageViewToo.frame.origin.y+messageViewToo.frame.size.height+5, SUPERVIEWWIDTH-20, 20)];
    Protocolview.backgroundColor=[UIColor clearColor];
    [_backGround addSubview:Protocolview];
    
    UIButton *btnAgree=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAgree.frame=CGRectMake(0, 0, 20, 20);
    [btnAgree setBackgroundImage:[UIImage imageNamed:@"Public_agree.png"] forState:UIControlStateNormal];
    [btnAgree addTarget:self action:@selector(agreebutton:) forControlEvents:UIControlEventTouchUpInside];
    isAgreeProtocol=YES;
    [Protocolview addSubview:btnAgree];
    isAgreeProtocol=YES;
    
    UILabel *lblagree=[[UILabel alloc]init];
    lblagree.frame=CGRectMake(20, 0, 30, 20);
    //同意
    [lblagree setText:[langSetting localizedString:@"Agree"]];
    lblagree.textAlignment=NSTextAlignmentCenter;
    lblagree.backgroundColor=[UIColor clearColor];
    lblagree.font=[UIFont systemFontOfSize:12];
    [lblagree setTextColor:[UIColor blackColor]];
    [Protocolview addSubview:lblagree];
    
    UIButton *btnUserProtocol=[UIButton buttonWithType:UIButtonTypeCustom];
    btnUserProtocol.frame=CGRectMake(50, 0, 80, 20);
//    用户协议
    [btnUserProtocol setTitle:[NSString stringWithFormat:@"《%@》",[langSetting localizedString:@"User agreement"]] forState:UIControlStateNormal];
    btnUserProtocol.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnUserProtocol addTarget:self action:@selector(selectorProtocol) forControlEvents:UIControlEventTouchUpInside];
    [btnUserProtocol setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Protocolview addSubview:btnUserProtocol];
    
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, messageViewToo.frame.origin.y+messageViewToo.frame.size.height+40, SUPERVIEWWIDTH-20, 30);
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

    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:control];
    [_backGround sendSubviewToBack:control];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoaryShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoaryHidde) name:UIKeyboardWillHideNotification object:nil];
}

-(void)controlClick
{
    [_tfPhoneNum resignFirstResponder];
}

-(void)keyBoaryShow
{
    [UIView animateWithDuration:0.2 animations:^{
        _backGround.frame = CGRectMake(0,VIEWHRIGHT-40, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoaryHidde
{
    [UIView animateWithDuration:0.2 animations:^{
        _backGround.frame = CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    
}


//是否同归协议
-(void)agreebutton:(UIButton *)button
{
    if(isAgreeProtocol)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"Public_disagree.png"] forState:UIControlStateNormal];
        isAgreeProtocol=NO;
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"Public_agree.png"] forState:UIControlStateNormal];
        isAgreeProtocol=YES;
    }
}

//查看协议
-(void)selectorProtocol
{
    VipCheckSelectViewController *vipCheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectAgreement andTitleName:[langSetting localizedString:@"User agreement"] andsetResult:nil];
    [self.navigationController pushViewController:vipCheck animated:YES];

}


-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if((textField==_tfPhoneNum && [_tfPhoneNum.text length]<=0 &&[string isEqualToString:@"0"]) || [_tfPhoneNum.text length]>10)
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


-(void)changeButtonClick:(UIButton *)button
{
    [self controlClick];
    if([_tfPhoneNum.text length]==0 || [_tfPhoneNum.text length]!=11 ||(![_tfPhoneNum.text isEqualToString:[_info objectForKey:@"tele"]]))
    {
//        请输入办理会员卡是预留的手机号码
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Please enter the card is reserved phone number"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
            [alert show];
        });

    }
    else if (![_tfPhoneNum.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆绑定的手机号码与会员绑定手机号码不符，不可添加绑定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if(isAgreeProtocol)
        {
            [DataProvider sharedInstance].authorPhoe=_tfPhoneNum.text;
            VipAuthorViewController *vipcard=[[VipAuthorViewController alloc]init];
            [vipcard setPersonInfo:_info];
            [self.navigationController pushViewController:vipcard animated:YES];
        }
        else
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Please see the 《user agreement》"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                [alert show];
            });
           
        }
    }
    
    
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
