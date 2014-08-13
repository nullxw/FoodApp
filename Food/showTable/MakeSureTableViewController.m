//
//  MakeSureTableViewController.m
//  Food
//
//  Created by sundaoran on 14-4-3.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "MakeSureTableViewController.h"
#import "DataProvider.h"
#import "StoreMessage.h"
#import "BSBookViewController.h"
#import "changeCity.h"


@interface MakeSureTableViewController ()

@end

@implementation MakeSureTableViewController
{
    CGFloat         VIEWSELFHEIGHT;
    UIScrollView          *_backgroundView;
    
    UITextField     *_tfPeopleNum;
    UITextField     *_tfPhoneNum;
    UITextField     *_tfverify;
    
    UIButton        *_btSelectTime;
    
    UILabel         *_lblStoretele;
    
//    UITextView      *_textView;
    UITableView     *_tableView;
    
    NSString        *AuthouNum;//验证码
    
    CVLocalizationSetting   *langSetting;
    
    UIButton *btnverify;
    BOOL        _getAuthor;//是否获取了验证码
    
    int         minCount;//验证码倒计时
    NSTimer     *minCountTimer;//验证码计时器
    
    NSDictionary   *sendTableInfo;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    minCount =0;
    langSetting=[CVLocalizationSetting sharedInstance];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWSELFHEIGHT=64.0;
    }
    else
    {
        VIEWSELFHEIGHT=44.0;
    }
   
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    _backgroundView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, VIEWSELFHEIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT)];
    [self.view addSubview:_backgroundView];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWSELFHEIGHT) andTitle:[langSetting localizedString:@"Reservation information"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    if([DataProvider sharedInstance].storeMessage!=nil)
    {
        [self creatView:[DataProvider sharedInstance].storeMessage];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"选择门店信息错误\n返回重新选择"];
    }
}

-(void)creatView:(StoreMessage *)storeMessage
{
    CGFloat     labeltitleWidth=80.0f;// 左侧标题宽度
    CGFloat     lblMessageWidth=195.f;//  右列内容宽度
    CGFloat     messagelblx=105.0f;//右列内容x
    CGFloat     titlelblx=20.0f;//  左列x
    CGFloat     lblHeight=30.0f;    //高度
    NSLog(@"%@",storeMessage.storetableId);
    
    UILabel  *lblName=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, 20, labeltitleWidth, lblHeight)];
//    店名
    lblName.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Stores"]];
    lblName.textColor=[UIColor blackColor];
    lblName.backgroundColor=[UIColor whiteColor];
    lblName.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblName];
    
    UILabel  *lblStoreName=[[UILabel alloc]initWithFrame:CGRectMake(messagelblx, 20, lblMessageWidth, lblHeight)];
    lblStoreName.text=storeMessage.storeFirmdes;
    lblStoreName.textColor=[UIColor blackColor];
    lblStoreName.backgroundColor=[UIColor whiteColor];
    lblStoreName.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblStoreName];
    
    UILabel  *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, 20+1*(lblHeight+10), labeltitleWidth, lblHeight)];
//    日期
    lblDate.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Date"]];
    lblDate.textColor=[UIColor blackColor];
    lblDate.backgroundColor=[UIColor whiteColor];
    lblDate.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblDate];
    
    
    UILabel  *lblStoreDate=[[UILabel alloc]initWithFrame:CGRectMake(messagelblx, 20+1*(lblHeight+10), lblMessageWidth, lblHeight)];
    lblStoreDate.text=[NSString stringWithFormat:@"%@  %@",[DataProvider sharedInstance].selectTime,[DataProvider sharedInstance].selectCanCi];
    lblStoreDate.textColor=[UIColor blackColor];
    lblStoreDate.backgroundColor=[UIColor whiteColor];
    lblStoreDate.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblStoreDate];
    
    UILabel  *lblTime=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, 20+2*(lblHeight+10), labeltitleWidth, lblHeight)];
//    时间
    lblTime.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Time"]];
    lblTime.textColor=[UIColor blackColor];
    lblTime.backgroundColor=[UIColor whiteColor];
    lblTime.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblTime];
    
    
    _btSelectTime=[UIButton buttonWithType:UIButtonTypeCustom];
    _btSelectTime.layer.borderWidth=0.5;
    _btSelectTime.layer.cornerRadius=5;
    _btSelectTime.layer.borderColor=selfborderColor.CGColor;
    _btSelectTime.frame=CGRectMake(messagelblx, 20+2*(lblHeight+10), lblMessageWidth-70, lblHeight);
    [_btSelectTime setTitle:[DataProvider sharedInstance].StartTime forState:UIControlStateNormal];
    
    
    UILabel *lblPop=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, 20+2*(lblHeight+10)+lblHeight, _backgroundView.frame.size.width-messagelblx, 35)];
    lblPop.text=@"友情提示：预约桌位将为您保留15分钟，请合理安排就餐时间";
    lblPop.textAlignment=NSTextAlignmentLeft;
    lblPop.font=[UIFont systemFontOfSize:12];
    lblPop.textColor=selfbackgroundColor;
    lblPop.backgroundColor=[UIColor clearColor];
    lblPop.numberOfLines=0;
    lblPop.lineBreakMode=NSLineBreakByWordWrapping;
    [_backgroundView addSubview:lblPop];
    
    UIImageView *right=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_arrows.png"]];
    right.frame=CGRectMake(_btSelectTime.frame.size.width-20, (lblHeight-20)/2, 20, 20);
    [_btSelectTime addSubview:right];
    
    [_btSelectTime setBackgroundColor:[UIColor whiteColor]];
    [_btSelectTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btSelectTime addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _btSelectTime.tag=101;
    [_backgroundView addSubview:_btSelectTime];
    
    float heightIndex=15.0f;
    
    UILabel  *lblPeopleNum=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, heightIndex+30+3*(lblHeight+10), labeltitleWidth, lblHeight)];
//    人数
    lblPeopleNum.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"People"]];
    lblPeopleNum.textColor=[UIColor blackColor];
    lblPeopleNum.backgroundColor=[UIColor whiteColor];
    lblPeopleNum.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblPeopleNum];
    
    _tfPeopleNum=[[UITextField alloc]initWithFrame:CGRectMake(messagelblx, heightIndex+30+3*(lblHeight+10), lblMessageWidth, lblHeight)];
    _tfPeopleNum.delegate=self;
    _tfPeopleNum.borderStyle=UITextBorderStyleRoundedRect;
    _tfPeopleNum.keyboardType=UIKeyboardTypeNumberPad;
    _tfPeopleNum.clearButtonMode=UITextFieldViewModeAlways;
//    请输入订餐人数
    _tfPeopleNum.placeholder=[langSetting localizedString:@"Enter the order number"];
    [_backgroundView addSubview:_tfPeopleNum];
    
    
    UILabel  *lblPhone=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, heightIndex+30+4*(lblHeight+10), labeltitleWidth, lblHeight)];
//    手机
    lblPhone.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Phone number"]];
    lblPhone.textColor=[UIColor blackColor];
    lblPhone.backgroundColor=[UIColor whiteColor];
    lblPhone.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblPhone];
    
    _tfPhoneNum=[[UITextField alloc]initWithFrame:CGRectMake(messagelblx, heightIndex+30+4*(lblHeight+10), lblMessageWidth, lblHeight)];
    _tfPhoneNum.delegate=self;
    _tfPhoneNum.borderStyle=UITextBorderStyleRoundedRect;
    _tfPhoneNum.keyboardType=UIKeyboardTypeNumberPad;
    _tfPhoneNum.clearButtonMode=UITextFieldViewModeAlways;
    _tfPhoneNum.placeholder=[langSetting localizedString:@"Please enter the phone number"];
    [_backgroundView addSubview:_tfPhoneNum];
    
    UILabel  *lblverify=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, heightIndex+30+5*(lblHeight+10), labeltitleWidth, lblHeight)];
    lblverify.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Verification code"]];
    lblverify.textColor=[UIColor blackColor];
    lblverify.backgroundColor=[UIColor whiteColor];
    lblverify.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblverify];
    
    
    _tfverify=[[UITextField alloc]initWithFrame:CGRectMake(messagelblx, heightIndex+30+5*(lblHeight+10), lblMessageWidth/2, lblHeight)];
    _tfverify.delegate=self;
    _tfverify.borderStyle=UITextBorderStyleRoundedRect;
    _tfverify.keyboardType=UIKeyboardTypeNumberPad;
    _tfverify.clearButtonMode=UITextFieldViewModeAlways;
    _tfverify.placeholder=[langSetting localizedString:@"Please enter the verification code"];
    [_backgroundView addSubview:_tfverify];
    
    btnverify=[UIButton buttonWithType:UIButtonTypeCustom];
    btnverify.frame=CGRectMake(messagelblx+lblMessageWidth/2+10, heightIndex+30+5*(lblHeight+10), lblMessageWidth/2, lblHeight);
    [btnverify setTitle:[langSetting localizedString:@"Get verification code"] forState:UIControlStateNormal];
    [btnverify setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
    [btnverify setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
    btnverify.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnverify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnverify addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnverify.tag=102;
    [_backgroundView addSubview:btnverify];
    
    
    UILabel  *lblAddr=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, heightIndex+40+6*(lblHeight+10), labeltitleWidth, lblHeight)];
    lblAddr.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Address"]];
    lblAddr.textColor=[UIColor blackColor];
    lblAddr.backgroundColor=[UIColor whiteColor];
    lblAddr.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lblAddr];
    
    UILabel  *lblStoreAddr=[[UILabel alloc]initWithFrame:CGRectMake(messagelblx, heightIndex+30+6*(lblHeight+10), lblMessageWidth, lblHeight+20)];
    lblStoreAddr.text=storeMessage.storeAddr;
    lblStoreAddr.numberOfLines=2;
    lblStoreAddr.lineBreakMode=NSLineBreakByWordWrapping;
    lblStoreAddr.textColor=[UIColor blackColor];
    lblStoreAddr.backgroundColor=[UIColor whiteColor];
    lblStoreAddr.font=[UIFont systemFontOfSize:15];
    [_backgroundView addSubview:lblStoreAddr];
    
    
    UILabel  *lbltele=[[UILabel alloc]initWithFrame:CGRectMake(titlelblx, heightIndex+50+7*(lblHeight+10), labeltitleWidth, lblHeight)];
    lbltele.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Telephone"]];
    lbltele.textColor=[UIColor blackColor];
    lbltele.backgroundColor=[UIColor whiteColor];
    lbltele.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:lbltele];
    
    _lblStoretele=[[UILabel alloc]initWithFrame:CGRectMake(messagelblx, heightIndex+50+7*(lblHeight+10), lblMessageWidth-30, lblHeight)];
    _lblStoretele.text=storeMessage.storeTele;
    _lblStoretele.textColor=[UIColor blackColor];
    _lblStoretele.backgroundColor=[UIColor whiteColor];
    _lblStoretele.font=[UIFont systemFontOfSize:17];
    [_backgroundView addSubview:_lblStoretele];
    
    UIButton *btCallNum=[UIButton buttonWithType:UIButtonTypeCustom];
    btCallNum.frame=CGRectMake(messagelblx+165, heightIndex+50+7*(lblHeight+10), 30, lblHeight-8);
    [btCallNum setBackgroundImage:[UIImage imageNamed:@"Public_callphone.png"] forState:UIControlStateNormal];
    [btCallNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btCallNum addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btCallNum.tag=103;
    [_backgroundView addSubview:btCallNum];
    
//    _textView=[[UITextView alloc]initWithFrame:CGRectMake(titlelblx, 40+8*(lblHeight+10), SUPERVIEWWIDTH-titlelblx*2, 50)];
//    _textView.layer.borderColor=selfborderColor.CGColor;
//    _textView.layer.borderWidth=0.5;
////    请输入您的特殊要求!
//    NSString *strAddition = [[NSUserDefaults standardUserDefaults] objectForKey:@"addition"];
//    if ([strAddition isEqualToString:@""]) {
//        _textView.text = [langSetting localizedString:@"Special requirements"];
//    }else{
//        _textView.text = strAddition;
//    }
//    _textView.delegate=self;
//    [_backgroundView addSubview:_textView];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
                                        //60
    nextButton.frame=CGRectMake(titlelblx, heightIndex+20+9*(lblHeight+10), SUPERVIEWWIDTH-titlelblx*2, lblHeight);
    [nextButton setTitle:[langSetting localizedString:@"Next step"] forState:UIControlStateNormal];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag=104;
    [_backgroundView addSubview:nextButton];
    
    [_backgroundView setContentSize:CGSizeMake(SUPERVIEWWIDTH, nextButton.frame.origin.y+120)];
    
    UIControl *control=[[UIControl alloc]initWithFrame:_backgroundView.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:control];
    [_backgroundView sendSubviewToBack:control];
    
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

}
-(void)ButtonClick:(UIButton *)button
{
    if(button.tag==101)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectTime andName:[DataProvider sharedInstance].selectCanCi];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }
    else if(button.tag==102)
    {
        if([_tfPhoneNum.text length]!=11)
        {
//            请输入正确的手机号码
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please correct phone number"]];

        }
        else
        {
            if(!_getAuthor)
            {
                [btnverify setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btnverify setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
                [btnverify setBackgroundColor:[UIColor grayColor]];
             minCountTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(canGetAuthor) userInfo:nil repeats:YES];
                _getAuthor=YES;
                [NSThread detachNewThreadSelector:@selector(getAuthor:) toTarget:self withObject:_tfPhoneNum.text];
            }
            
        }
    }
    else if(button.tag==103)
    {
        [self.view addSubview:[DataProvider callPhoneOrtele:_lblStoretele.text]];
    }
    else if(button.tag==104)
    {
        if([_tfPeopleNum.text length]==0)
        {
//            请输就餐人数
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please enter the order People"]];
        }
        else if ([_tfPhoneNum.text length]!=11)
        {
//            请输入正确的手机号码
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please correct phone number"]];
        }
        else if(!_getAuthor)
        {
//            未获取验证码
            [SVProgressHUD showErrorWithStatus:@"请获取验证码"];
        }
        else if ([_tfverify.text length]!=6)
        {
//            请输入正确的6位验证
          [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please enter the verification code"]];
        }
        else if (![_tfverify.text isEqualToString:AuthouNum])
        {
          [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
        }
        else if (![DataProvider compareNowTime:[NSString stringWithFormat:@"%@ %@",[DataProvider sharedInstance].selectTime,_btSelectTime.titleLabel.text]])
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"您选择的门店\n最晚可预点时间早于当前时间\n请选择其他门店\n或重新选择餐次" delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
            });

        }
        else
        {
            
            //        dat :日期    sft：餐次  mobtel：手机号  type：1：大厅 0：包间   idorpax：名称  firmid ：门店id clientid：客户id
            DataProvider *dp=[DataProvider sharedInstance];
            NSMutableDictionary *info=[[NSMutableDictionary alloc]init];
            [info setObject:dp.selectTime forKey:@"dat"];
            if([dp.selectCanCi isEqualToString:@"午餐"])
            {
                [info setObject:@"1" forKey:@"sft"];
            }
            else
            {
                [info setObject:@"2" forKey:@"sft"];
            }
            
            [info setObject:_btSelectTime.titleLabel.text forKey:@"datmins"];
            [info setObject:_tfPhoneNum.text forKey:@"mobtel"];
            if(dp.isRoom)
            {
                [info setObject:[NSString stringWithFormat:@"0"] forKey:@"type"];
            }
            else
            {
                [info setObject:[NSString stringWithFormat:@"1"] forKey:@"type"];
            }
            
            [info setObject:dp.selecttableName forKey:@"idorpax"];
            [info setObject:dp.storeMessage.storeFirmid forKey:@"firmId"];
            [info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"clientId"];
            [info setObject:_tfPeopleNum.text forKey:@"pax"];
            
            sendTableInfo=info;
            
            //            订单成功\n是否点餐
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@\n%@",[langSetting localizedString:@"Successful order"],[langSetting localizedString:@"Whether to order a meal"]] delegate:self cancelButtonTitle:[langSetting localizedString:@"No"] otherButtonTitles:[langSetting localizedString:@"Sure"], nil];
                alert.tag=1001;
                [alert show];
            });

//            [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
//            [NSThread detachNewThreadSelector:@selector(sendTableMessage) toTarget:self withObject:nil];
            
        }
    }
    
}


-(void)sendTableMessage
{
    @autoreleasepool
    {
        
        DataProvider *dp=[DataProvider sharedInstance];
        
        NSDictionary *dict=[dp sendTableMessage:[[NSMutableDictionary alloc]initWithDictionary:sendTableInfo]];
        
        if ([[dict objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            dp.phoneNum=_tfPhoneNum.text;
            dp.tableId=[dict objectForKey:@"Message"];
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"订单可为您预留15分钟，超时作废\n请合理安排就餐时间" delegate:self cancelButtonTitle:[langSetting localizedString:@"Sure"] otherButtonTitles:nil];
                alert.tag=1002;
                [alert show];
            });
            
////            订单成功\n是否点餐
//            bs_dispatch_sync_on_main_thread(^{
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@\n%@",[langSetting localizedString:@"Successful order"],[langSetting localizedString:@"Whether to order a meal"]] delegate:self cancelButtonTitle:[langSetting localizedString:@"No"] otherButtonTitles:[langSetting localizedString:@"Sure"], nil];
//                alert.tag=1001;
//                [alert show];
//            });
            
        }else
        {
//            获取失败
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
        }
        
    }
}
-(void)controlClick
{
    [_tfPeopleNum resignFirstResponder];
    [_tfPhoneNum resignFirstResponder];
    [_tfverify resignFirstResponder];
//    [_textView resignFirstResponder];
}

-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3 animations:^{
          _backgroundView.frame=CGRectMake(0, VIEWSELFHEIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark    textViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.frame=CGRectMake(0,-(textView.frame.origin.y-VIEWSELFHEIGHT-100), SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    textView.text=@"";
    return YES;
}
#pragma mark textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat  height=VIEWSELFHEIGHT;
    if(textField==_tfPeopleNum)
    {
        height= 20+3*(30+10)-VIEWSELFHEIGHT-20;
    }
    else if (textField==_tfPhoneNum)
    {
        height= 20+4*(30+10)-VIEWSELFHEIGHT-20;
    }
    else if (textField==_tfverify)
    {
        height= 20+5*(30+10)-VIEWSELFHEIGHT-20;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.frame=CGRectMake(0, -height, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    //    您还有什么需求，请再次留言！
    [self textchange:textView];
    return YES;
}

-(void)textchange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]||[textView.text isEqualToString:[langSetting localizedString:@"Special requirements"]])
    {
        //        您还有什么需求，请再次留言！
        textView.text=[langSetting localizedString:@"Special requirements"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:textView.text forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
        if((textField==_tfPhoneNum && [_tfPhoneNum.text length]<=0 &&[string isEqualToString:@"0"]) || [_tfPeopleNum.text length]>10)
        {
            return NO;
        }
        else if (textField==_tfPeopleNum && [_tfPeopleNum.text length]>1)
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


#pragma mark  时间选择代理

-(void)setTime:(NSString *)time
{
    [_btSelectTime setTitle:time forState:UIControlStateNormal];
}


//手机验证码获取
-(void)getAuthor:(NSString *)string
{
    @autoreleasepool {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dic = [dp getPhoneAuthCode:string];
        if ([[dic objectForKey:@"Result"] boolValue]) {
//            111111
            AuthouNum=[dic objectForKey:@"Message"];
            
//            AuthouNum=@"111111";
            
        }else
        {
//            获取失败
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
            minCount=60;//触发重新获取验证码可点
            [self canGetAuthor];
        }
    }
}

-(void)canGetAuthor
{
    if(minCount<60)
    {
        minCount+=1;
        [btnverify setTitle:[NSString stringWithFormat:@"%d秒重新获取",60-minCount] forState:UIControlStateNormal];
    }
    else
    {
        minCount=0;
        [minCountTimer invalidate];
        [btnverify setTitle:[langSetting localizedString:@"Get verification code"] forState:UIControlStateNormal];
    [btnverify setBackgroundImage:[UIImage imageNamed:@"Public_AuthorNomal.png"] forState:UIControlStateNormal];
    [btnverify setBackgroundImage:[UIImage imageNamed:@"Public_AuthorSelect.png"] forState:UIControlStateHighlighted];
    _getAuthor=NO;
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(1001==alertView.tag)
    {
        if (buttonIndex==1)
        {
    

            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            DataProvider *dp=[DataProvider sharedInstance];
            [dic setObject:((changeCity *)dp.selectCity).selectproviceId forKey:@"city"];
            NSMutableDictionary *valueStore=[[NSMutableDictionary alloc]init];
            
            [valueStore setObject:dp.storeMessage.storeFirmid forKey:@"firmid"];
            [valueStore setObject:dp.storeMessage.storeFirmdes forKey:@"firmdes"];
            [valueStore setObject:dp.storeMessage.storeInit forKey:@"init"];
            [valueStore setObject:dp.storeMessage.storeTele forKey:@"tele"];
            [valueStore setObject:dp.storeMessage.storeArea forKey:@"area"];
            
            [dic setObject:valueStore forKey:@"Store"];
            [dic setObject:_btSelectTime.titleLabel.text forKey:@"Date"];
            [dic setObject:dp.selectCanCi forKey:@"shiBie"];
            [dic setObject:dp.selectTime forKey:@"targetDate"];
            
            BSBookViewController *book = [[BSBookViewController alloc] init];
            book.dicInfo = dic;
            book.sendTableInf=sendTableInfo;
            [self.navigationController pushViewController:book animated:YES];
            //        [self textchange:_textView];
            
        }
        else
        {
            
            [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(sendTableMessage) toTarget:self withObject:nil];


        }
    }
    else if(1002==alertView.tag)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



#pragma mark    avigationBardelegate
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
