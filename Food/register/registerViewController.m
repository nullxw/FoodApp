//
//  registerViewController.m
//  Food
//
//  Created by sundaoran on 14-3-27.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "registerViewController.h"
#import "DataProvider.h"
#import "MenuViewController.h"
#import "NewMenuViewController.h"

@interface registerViewController ()

@end

@implementation registerViewController
{
    
    CGFloat                 VIEWHEIGHT;//导航条高度
    CGFloat                 lastViewHeigth;//提交钱视图高度
    UIScrollView            *_background;
    UITextField             *userName;
    UITextField             *passWord;
    UITextField             *passWordSure;
    
    NSMutableArray          *_allButtonArray;   //保存所有button的数组
    
    NSString                *_changeSex;
    NSString                *_changeProvince;
    NSString                *_changeCity;
    NSString                *_changeArea;
    
    typeSelectViewViewController   * typeView;
    
    UILabel *lblShengFenName;
    UILabel *lblChengshiName;
    UILabel *lblDiquName;
    
    CVLocalizationSetting *langSetting;
    
}
@synthesize isChange=_isChange;
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
    self.view.backgroundColor=[UIColor whiteColor];

    _changeProvince=@"";
    _changeCity=@"";
    _changeArea=@"";
    _allButtonArray =[[NSMutableArray alloc]init];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHEIGHT=64;
    }
    else
    {
        VIEWHEIGHT=44;
    }
    UIImageView *backGroundImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    backGroundImageView.frame=self.view.bounds;
    backGroundImageView.userInteractionEnabled=YES;
    [self.view addSubview:backGroundImageView];
    
    UIView *nvc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHEIGHT)];
    nvc.backgroundColor=selfbackgroundColor;
    [self.view addSubview:nvc];
    
    UILabel *lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0, nvc.frame.size.height-44, nvc.frame.size.width, 44)];
    lbltitle.text=[langSetting localizedString:@"Improve the personal information"];
    lbltitle.textAlignment=NSTextAlignmentCenter;
    lbltitle.font=[UIFont systemFontOfSize:17];
    lbltitle.textColor=[UIColor whiteColor];
    [nvc addSubview:lbltitle];
    
    _background=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _background.backgroundColor=[UIColor clearColor];
    [backGroundImageView addSubview:_background];
    
    
    
    for (int i=0; i<7; i++)
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, i%7*45+VIEWHEIGHT+10, SUPERVIEWWIDTH-20, 36)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderColor=selfborderColor.CGColor;
        view.layer.borderWidth=0.3;
        view.layer.cornerRadius=3;
        [_background addSubview:view];
        
        UIImageView *imageLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 20, 20) ];
        
        [view addSubview:imageLeft];
        switch (i) {
            case 0:
            {
                [imageLeft setImage:[UIImage imageNamed:@"Public_white.png"]];
                UILabel *lbluserName=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 65, 30)];
                lbluserName.text=[langSetting localizedString:@"User name"];
                lbluserName.backgroundColor=[UIColor clearColor];
                lbluserName.textAlignment=NSTextAlignmentLeft;
                lbluserName.font=[UIFont systemFontOfSize:17];
                lbluserName.textColor=[UIColor blackColor];
                [view addSubview:lbluserName];
                
                userName =[[UITextField alloc]initWithFrame:CGRectMake(95, 3, view.frame.size.width-110, 30)];
                userName.clearButtonMode=UITextFieldViewModeWhileEditing;
                userName.borderStyle=UITextBorderStyleNone;
                userName.placeholder=[langSetting localizedString:@"Please enter your user name"];
                [view addSubview:userName];
            }
                break;
            case 1:
            {
                UIButton *manButton=[UIButton buttonWithType:UIButtonTypeCustom];
                manButton.backgroundColor=[UIColor clearColor];
                manButton.frame=CGRectMake(50, 3, 80, 30);
                manButton.tag=101;
                [manButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_allButtonArray addObject:manButton];
                [view addSubview:manButton];
                
                UIImageView *imagemanLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
                [imagemanLeft setImage:[UIImage imageNamed:@"Public_sexSelect.png"]];
                [manButton addSubview:imagemanLeft];
                UILabel *lbluserManName=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 30)];
                lbluserManName.text=[langSetting localizedString:@"man"];
                lbluserManName.backgroundColor=[UIColor clearColor];
                lbluserManName.textAlignment=NSTextAlignmentCenter;
                lbluserManName.font=[UIFont systemFontOfSize:17];
                lbluserManName.textColor=[UIColor blackColor];
                [manButton addSubview:lbluserManName];
                _changeSex=@"0";//男士
                
                UIButton *woManButton=[UIButton buttonWithType:UIButtonTypeCustom];
                woManButton.backgroundColor=[UIColor clearColor];
                woManButton.frame=CGRectMake(190, 3, 80, 30);
                woManButton.tag=102;
                [woManButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_allButtonArray addObject:woManButton];
                [view addSubview:woManButton];
                
                UIImageView *imageWomanLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
                [imageWomanLeft setImage:[UIImage imageNamed:@"Public_sexNomal.png"]];
                [woManButton addSubview:imageWomanLeft];
                UILabel *lbluserWomanName=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 30)];
                lbluserWomanName.text=[langSetting localizedString:@"woman"];
                lbluserWomanName.backgroundColor=[UIColor clearColor];
                lbluserWomanName.textAlignment=NSTextAlignmentCenter;
                lbluserWomanName.font=[UIFont systemFontOfSize:17];
                lbluserWomanName.textColor=[UIColor blackColor];
                [woManButton addSubview:lbluserWomanName];
                
            }
                break;
            case 2:
            {
                
                [imageLeft setImage:[UIImage imageNamed:@"Public_white.png"]];
                
                UILabel *lbluserWomanName=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 70, 30)];
                lbluserWomanName.text=[langSetting localizedString:@"Please enter the password"];
                lbluserWomanName.backgroundColor=[UIColor clearColor];
                lbluserWomanName.textAlignment=NSTextAlignmentLeft;
                lbluserWomanName.font=[UIFont systemFontOfSize:13];
                lbluserWomanName.textColor=[UIColor blackColor];
                [view addSubview:lbluserWomanName];
                
                passWord =[[UITextField alloc]initWithFrame:CGRectMake(100, 3, view.frame.size.width-110, 30)];
                passWord.clearButtonMode=UITextFieldViewModeWhileEditing;
                passWord.borderStyle=UITextBorderStyleNone;
                passWord.secureTextEntry=YES;
                passWord.delegate=self;
                passWord.placeholder=[langSetting localizedString:@"passWordPrompt"];
                [view addSubview:passWord];
            }
                break;
            case 3:
            {
                [imageLeft setImage:[UIImage imageNamed:@"Public_white.png"]];
                
                UILabel *lbluserWomanName=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 70, 30)];
                lbluserWomanName.text=[langSetting localizedString:@"Please make sure the password"];
                lbluserWomanName.backgroundColor=[UIColor clearColor];
                lbluserWomanName.textAlignment=NSTextAlignmentLeft;
                lbluserWomanName.font=[UIFont systemFontOfSize:13];
                lbluserWomanName.textColor=[UIColor blackColor];
                [view addSubview:lbluserWomanName];
                
                passWordSure =[[UITextField alloc]initWithFrame:CGRectMake(100, 3, view.frame.size.width-110, 30)];
                passWordSure.clearButtonMode=UITextFieldViewModeWhileEditing;
                passWordSure.borderStyle=UITextBorderStyleNone;
                passWordSure.secureTextEntry=YES;
                passWordSure.delegate=self;
                passWordSure.placeholder=[langSetting localizedString:@"passWordPrompt"];
                [view addSubview:passWordSure];
            }
                break;
            case 4:
            {
                [imageLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
                
                UIButton *btnShenFen=[UIButton buttonWithType:UIButtonTypeCustom];
                btnShenFen.backgroundColor=[UIColor clearColor];
                btnShenFen.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                btnShenFen.tag=103;
                [btnShenFen addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnShenFen];
                
                UILabel *lblShengFen=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 45, 30)];
                lblShengFen.text=[langSetting localizedString:@"province"];
                lblShengFen.textColor=[UIColor blackColor];
                lblShengFen.backgroundColor=[UIColor clearColor];
                [btnShenFen addSubview:lblShengFen];
                
                lblShengFenName=[[UILabel alloc]initWithFrame:CGRectMake(80, 3,120, 30)];
                lblShengFenName.text=[langSetting localizedString:@"Please select a province"];
                lblShengFenName.textColor=[UIColor grayColor];
                lblShengFenName.font=[UIFont systemFontOfSize:15];
                lblShengFenName.backgroundColor=[UIColor clearColor];
                [btnShenFen addSubview:lblShengFenName];
                
                UIImageView *imagemanLeft=[[UIImageView alloc]initWithFrame:CGRectMake(SUPERVIEWWIDTH-40, 3, 20, 30)];
                [imagemanLeft setImage:[UIImage imageNamed:@"Public_arrows.png"]];
                [btnShenFen addSubview:imagemanLeft];
                
                //                btnShenFen=[UIButton buttonWithType:UIButtonTypeCustom];
                //                btnShenFen.backgroundColor=[UIColor greenColor];
                //                btnShenFen.frame=CGRectMake(90, 3, 120, 30);
                //                [btnShenFen setTitle:@"省份" forState:UIControlStateNormal];
                //                btnShenFen.tag=103;
                //                [btnShenFen addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                //                [view addSubview:btnShenFen];
                
                
            }
                break;
            case 5:
            {
                
                UIButton *btnCity=[UIButton buttonWithType:UIButtonTypeCustom];
                btnCity.backgroundColor=[UIColor clearColor];
                btnCity.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                btnCity.tag=104;
                [btnCity addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnCity];
                
                [imageLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
                UILabel *lblChengShi=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 45, 30)];
                lblChengShi.text=[langSetting localizedString:@"OnlyCity"];
                lblChengShi.textColor=[UIColor blackColor];
                lblChengShi.backgroundColor=[UIColor clearColor];
                [view addSubview:lblChengShi];
                
                lblChengshiName=[[UILabel alloc]initWithFrame:CGRectMake(80, 3,120, 30)];
                lblChengshiName.text=[langSetting localizedString:@"Please select a city"];
                lblChengshiName.textColor=[UIColor grayColor];
                lblChengshiName.font=[UIFont systemFontOfSize:15];
                lblChengshiName.backgroundColor=[UIColor clearColor];
                [btnCity addSubview:lblChengshiName];
                
                UIImageView *imagemanLeft=[[UIImageView alloc]initWithFrame:CGRectMake(SUPERVIEWWIDTH-40, 3, 20, 30)];
                [imagemanLeft setImage:[UIImage imageNamed:@"Public_arrows.png"]];
                [btnCity addSubview:imagemanLeft];
                
                //                btnChengShi=[UIButton buttonWithType:UIButtonTypeCustom];
                //                btnChengShi.backgroundColor=[UIColor greenColor];
                //                btnChengShi.frame=CGRectMake(90, 3, 120, 30);
                //                [btnChengShi setTitle:@"城市" forState:UIControlStateNormal];
                //                btnChengShi.tag=104;
                //                [btnChengShi addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                //                [view addSubview:btnChengShi];
            }
                break;
            case 6:
            {
                UIButton *btnArea=[UIButton buttonWithType:UIButtonTypeCustom];
                btnArea.backgroundColor=[UIColor clearColor];
                btnArea.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                btnArea.tag=105;
                [btnArea addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btnArea];
                
                [imageLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
                UILabel *lblChengShi=[[UILabel alloc]initWithFrame:CGRectMake(30, 3, 45, 30)];
                lblChengShi.text=[langSetting localizedString:@"area"];
                lblChengShi.textColor=[UIColor blackColor];
                lblChengShi.backgroundColor=[UIColor clearColor];
                [view addSubview:lblChengShi];
                
                
                lblDiquName=[[UILabel alloc]initWithFrame:CGRectMake(80, 3,120, 30)];
                lblDiquName.text=[langSetting localizedString:@"Please select a region"];
                lblDiquName.textColor=[UIColor grayColor];
                lblDiquName.font=[UIFont systemFontOfSize:15];
                lblDiquName.backgroundColor=[UIColor clearColor];
                [btnArea addSubview:lblDiquName];
                
                UIImageView *imagemanLeft=[[UIImageView alloc]initWithFrame:CGRectMake(SUPERVIEWWIDTH-40, 3, 20, 30)];
                [imagemanLeft setImage:[UIImage imageNamed:@"Public_arrows.png"]];
                [btnArea addSubview:imagemanLeft];
                
                lastViewHeigth=view.frame.origin.y+view.frame.size.height;
            }
                break;
            default:
                break;
        }
    }
    
    UIButton *tijiao=[UIButton buttonWithType:UIButtonTypeCustom];
    [tijiao setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [tijiao setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    tijiao.frame=CGRectMake(10, lastViewHeigth+50, SUPERVIEWWIDTH-20, 30);
    [tijiao setTitle:[langSetting localizedString:@"Submit"] forState:UIControlStateNormal];
    tijiao.tag=106;
    [tijiao addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:tijiao];
    
    UIButton *jumpPass=[UIButton buttonWithType:UIButtonTypeCustom];
    jumpPass.backgroundColor=[UIColor clearColor];
    jumpPass.frame=CGRectMake(240, tijiao.frame.origin.y+50, 70, 30);
    [jumpPass setTitle:[langSetting localizedString:@"skip"] forState:UIControlStateNormal];
    jumpPass.tag=107;
    [jumpPass setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [jumpPass addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:jumpPass];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, 27, 40, 0.5)];
    line.backgroundColor=[UIColor blueColor];
    [jumpPass addSubview:line];
    
    [_background setContentSize:CGSizeMake(SUPERVIEWWIDTH, tijiao.frame.origin.y+120)];
    
    UIControl *control=[[UIControl alloc]initWithFrame:_background.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:control];
    [_background sendSubviewToBack:control];
    
}

-(void)controlClick
{
    [userName resignFirstResponder];
    [passWordSure resignFirstResponder];
    [passWord resignFirstResponder];
}

-(void)ButtonClick:(UIButton *)button
{
    if(button.tag==101||button.tag==102)
    {
        for (UIButton *btn in _allButtonArray)
        {
            if(btn==button)
            {
                for (NSObject *view in button.subviews)
                {
                    if([view isKindOfClass:[UIImageView class]])
                    {
                        [(UIImageView *)view setImage:[UIImage imageNamed:@"Public_sexSelect.png"]];
                    }
                }
                if(button.tag==101)
                {
                    _changeSex=@"0";
                }
                else if (button.tag==102)
                {
                    _changeSex=@"1";
                }
                typeView=nil;
            }
            else
            {
                for (NSObject *view in btn.subviews)
                {
                    if([view isKindOfClass:[UIImageView class]])
                    {
                        [(UIImageView *)view setImage:[UIImage imageNamed:@"Public_sexNomal.png"]];
                        typeView=nil;
                    }
                }
                
            }
        }
    }
    else if(button.tag==103)
    {
        typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectProvice andName:nil];
        typeView.delegate=self;
    }
    else if(button.tag==104)
    {
        if([_changeProvince isEqualToString:@""])
        {
            [self showAlertView:[langSetting localizedString:@"You haven't choose province"]];
            typeView=nil;
        }
        else
        {
            typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectCiry andName:_changeProvince];
            typeView.delegate=self;
        }
    }
    else if (button.tag==105)
    {
        if([_changeProvince isEqualToString:@""])
        {
            [self showAlertView:[langSetting localizedString:@"You haven't choose city"]];
            typeView=nil;
        }
        else if ([_changeCity isEqualToString:@""])
        {
            [self showAlertView:[langSetting localizedString:@"You haven't choose region"]];
            typeView=nil;
        }
        else
        {
            typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectArea andName:_changeCity];
            typeView.delegate=self;
        }
    }
    else if(button.tag==106)
    {
        if([userName.text length]<6 ||[userName.text length]>11)
        {
            [self showAlertView:[langSetting localizedString:@"Please enter the user name six to ten"]];
            typeView=nil;
        }
        else if ([passWord.text length]==0 ||[passWord.text length]!=6)
        {
            [self showAlertView:[langSetting localizedString:@"Password length is not correct"]];
            typeView=nil;
        }
        else if ([passWordSure.text length]==0||[passWordSure.text length]!=6)
        {
            [self showAlertView:[langSetting localizedString:@"Password length is not correct"]];
            typeView=nil;
        }
        else if (![passWordSure.text isEqualToString:passWord.text])
        {
            [self showAlertView:[langSetting localizedString:@"Different input password twice, please confirm"]];
            typeView=nil;
        }
        else if ([_changeCity isEqualToString:@""])
        {
            [self showAlertView:[langSetting localizedString:@"You haven't choose city"]];
            typeView=nil;
        }
        else if ([_changeProvince isEqualToString:@""])
        {
            [self showAlertView:[langSetting localizedString:@"You haven't choose province"]];
            typeView=nil;
        }
        else
        {
            typeView=nil;
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            [dict setObject:userName.text forKey:@"userName"];
            [dict setObject:passWord.text forKey:@"passWord"];
            [dict setObject:_changeSex forKey:@"userSex"];
            [dict setObject:[NSString stringWithFormat:@"%@%@%@",lblShengFenName.text,lblChengshiName.text,lblDiquName.text] forKey:@"userAddr"];
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"])
            {
                [dict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"] forKey:@"telePhone"];
            }
            else
            {
                [dict setObject:@"" forKey:@"telePhone"];
            }
            
             [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread  detachNewThreadSelector:@selector(postPersonMessage:) toTarget:self withObject:dict];
            
        }
        
    }
    else if(button.tag==107)
    {
        bs_dispatch_sync_on_main_thread(^{
            typeView=nil;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否跳过信息填写" message:@"如果跳过\n您可在设置里重新更改绑定\n否则您将不可进行在线点餐等功能\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"跳过", nil];
            [alert show];
        });
        
    }
    else
    {
        NSLog(@"按键错误");
    }
    
    if(typeView!=nil)
    {
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
        
    }
}

-(void)postPersonMessage:(NSMutableDictionary *)dict
{
    @autoreleasepool
    {
        NSDictionary *dicPack= [[DataProvider sharedInstance]postPersonMessage:dict];
        if ([[dicPack objectForKey:@"Result"] boolValue]) {
            [SVProgressHUD dismiss];
            bs_dispatch_sync_on_main_thread(^{
                //                保存注册的个人信息
                [[NSUserDefaults standardUserDefaults]setObject:userName.text forKey:@"userName"];
                 [[NSUserDefaults standardUserDefaults]setObject:[dicPack objectForKey:@"Message"] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if(_isChange)
                {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                }
                else
                {
//                    MenuViewController *menu=[[MenuViewController alloc]init];
                    NewMenuViewController *menu=[[NewMenuViewController alloc]init];
//                    [self.navigationController pushViewController:menu animated:YES];
                    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:menu];
                    nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nvc animated:YES completion:^{
                        
                    }];
                }
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dicPack objectForKey:@"Message"]];
        }
    }
}



-(void)showAlertView:(NSString *)titleMessage
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:titleMessage delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    });
    
}


#pragma mark    alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1)
    {
        //如果为更改绑定，退回上一界面
        if(_isChange)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
        }
        else
        {
//            MenuViewController *menu=[[MenuViewController alloc]init];
            NewMenuViewController *menu=[[NewMenuViewController alloc]init];
            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:menu];
            nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nvc animated:YES completion:^{
                
            }];
        }

    }
}

#pragma mark  --TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        return YES;
    }
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

#pragma mark typeSelectViewViewControllerdelegae
-(void)setpro:(changeCity *)pro
{
    lblShengFenName.text=pro.selectprovice;
    _changeProvince=pro.selectproviceId;
    typeView=nil;
}
-(void)setCity:(changeCity *)city
{
    lblChengshiName.text=city.selectCity;
    _changeCity=city.selectCityId;
     typeView=nil;
}
-(void)setArea:(changeCity *)Area
{
    lblDiquName.text=Area.selectArea;
    _changeArea=Area.selectAreaId;
     typeView=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
