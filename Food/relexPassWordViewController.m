//
//  relexPassWordViewController.m
//  Food
//
//  Created by sundaoran on 14-5-16.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "relexPassWordViewController.h"
#import "VipAuthorViewController.h"

@interface relexPassWordViewController ()

@end

@implementation relexPassWordViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    CVLocalizationSetting *langSetting;
    
    UITextField         *_tfOld;
    UITextField         *_tfNew;
    UITextField         *_tfNewTwo;
    UITextField         *_tfPhoneNum;
    VipMessageClass        *_VipCardMessage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
    [self.view addSubview:_backGround];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Modify payment password"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    CGFloat width=ScreenHeight-20;
    CGFloat height=30;
    
    UIView *PersonView=[[UIView alloc]initWithFrame:CGRectMake(10,height, ScreenWidth-20, 165)];
    PersonView.backgroundColor=[UIColor whiteColor];
    PersonView.layer.borderColor=selfborderColor.CGColor;
    PersonView.layer.borderWidth=0.5;
    PersonView.layer.cornerRadius=5;
    [_backGround addSubview:PersonView];
    
    for (int i=0; i<4; i++)
    {
        
        UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, i*41+10, 20, 20)];
        [imageViewLeft setImage:[UIImage imageNamed:@"Public_white.png"]];
        [PersonView addSubview:imageViewLeft];
        
        UILabel  *lblLeft=[[UILabel alloc]init];
        lblLeft.frame=CGRectMake(30,i*41,75, 41);
        lblLeft.textAlignment=NSTextAlignmentLeft;
        lblLeft.backgroundColor=[UIColor clearColor];
        lblLeft.font=[UIFont systemFontOfSize:14];
        [lblLeft setTextColor:[UIColor blackColor]];
        
        if(i!=3)
        {
            UIImageView *lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
            lineView.frame=CGRectMake(0, (i+1)*41, PersonView.frame.size.width, 1);
            [PersonView addSubview:lineView];
        }
        
        [PersonView addSubview:lblLeft];
        switch (i) {
            case 0:
            {
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Original password"]]];
                _tfOld =[[UITextField alloc]initWithFrame:CGRectMake(105,(i*41)+5, width, 30)];
                _tfOld.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfOld.borderStyle=UITextBorderStyleNone;
                _tfOld.delegate=self;
                _tfOld.secureTextEntry=YES;
                _tfOld.font=[UIFont systemFontOfSize:14];
                _tfOld.placeholder=[langSetting localizedString:@"Lose the original password"];
                [PersonView addSubview:_tfOld];
            }
                break;
            case 1:
            {
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"New password"]]];
                _tfNew =[[UITextField alloc]initWithFrame:CGRectMake(105,(i*41)+5, width-115, 30)];
                _tfNew.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfNew.borderStyle=UITextBorderStyleNone;
                _tfNew.delegate=self;
                _tfNew.secureTextEntry=YES;
                _tfNew.font=[UIFont systemFontOfSize:14];
                _tfNew.placeholder=[langSetting localizedString:@"Enter a new password"];
                [PersonView addSubview:_tfNew];
            }
                break;
            case 2:
            {
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"New password confirm"]]];
                _tfNewTwo =[[UITextField alloc]initWithFrame:CGRectMake(105,(i*41)+5, width-115, 30)];
                _tfNewTwo.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfNewTwo.borderStyle=UITextBorderStyleNone;
                _tfNewTwo.delegate=self;
                _tfNewTwo.secureTextEntry=YES;
                _tfNewTwo.font=[UIFont systemFontOfSize:14];
                _tfNewTwo.placeholder=[langSetting localizedString:@"Make sure new password"];
                [PersonView addSubview:_tfNewTwo];
            }
                break;
            case 3:
            {
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"phone number"]]];
                _tfPhoneNum =[[UITextField alloc]initWithFrame:CGRectMake(105,(i*41)+5, width-115, 30)];
                _tfPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfPhoneNum.delegate=self;
                _tfPhoneNum.borderStyle=UITextBorderStyleNone;
                _tfPhoneNum.font=[UIFont systemFontOfSize:14];
                _tfPhoneNum.placeholder=[langSetting localizedString:@"Please enter the phone number"];
                _tfPhoneNum.keyboardType=UIKeyboardTypePhonePad;
                [PersonView addSubview:_tfPhoneNum];
            }
                break;
            default:
                break;
        }
    }

    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, PersonView.frame.origin.y+PersonView.frame.size.height+15, SUPERVIEWWIDTH-20, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    [nextButton  addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Submit"]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

//触发键盘隐藏事事件
-(void)controlClick
{
    [_tfNew resignFirstResponder];
    [_tfNewTwo resignFirstResponder];
    [_tfOld resignFirstResponder];
    [_tfPhoneNum resignFirstResponder];
}

//键盘隐藏后监测事件
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3f animations:^{
        _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
    } completion:^(BOOL finished) {
        
    }];
}


//触发改变密码界面跳转事件
-(void)changeButtonClick
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
    {
        //@"请先绑定手机号码"
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone"]];
    }
    else
    {
        if([_tfOld.text length]==0)
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Lose the original password"]];
        }
        else if ([_tfNew.text length]==0)
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Enter a new password"]];
        }
        else if ([_tfNewTwo.text length]==0)
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Make sure new password"]];
        }
        else if (![_tfNew.text isEqualToString:_tfNewTwo.text])
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Two different password, please make sure the input again"]];
        }
        else if ([_tfPhoneNum.text length]==0)
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please enter the phone number"]];
        }
//        else if (![_tfPhoneNum.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]])
//        {
//            [SVProgressHUD showErrorWithStatus:@"请输入办理会员卡是预留的手机号码"];
//        }
        else
        {
//            if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
//            {
//                //@"请先绑定手机号码"
//                [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
//            }
        
//            else
//            {
                VipAuthorViewController *author=[[VipAuthorViewController alloc]init];
                NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
                [Info setObject:_tfOld.text forKey:@"old"];
                [Info setObject:_tfNew.text forKey:@"new"];
                [Info setObject:_tfPhoneNum.text forKey:@"phone"];
                [author setChangePassWordInfo:Info];
                [self.navigationController pushViewController:author animated:YES];
//            }
        }
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat  moverHeight=0.0;
    if(!(ScreenHeight>480.0f || ScreenHeight>568))
    {
        if (textField!=_tfOld)
        {
            moverHeight=50.0f;
        }
        [UIView animateWithDuration:0.3f animations:^{
            _backGround.frame=CGRectMake(0,VIEWHRIGHT-moverHeight, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
  
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if(textField==_tfNew || textField==_tfNewTwo || textField==_tfOld)
        {
            if([textField.text length]>5)
            {
                [SVProgressHUD showErrorWithStatus:@"密码长度最长为六位字符数字或者字符"];
                return NO;
            }
        }
        if(textField!=_tfPhoneNum)
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
