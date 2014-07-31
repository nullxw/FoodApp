//
//  FreeClickViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "StarSelectCityViewController.h"
#import "DataProvider.h"
#import "OutletViewController.h"
#import "BSBookViewController.h"
#import "shareInfoData.h"
#import "privilegeViewController.h"
#import "StarRatingViewController.h"

@interface StarSelectCityViewController ()
{
    typeSelectViewViewController *typeView;
    BOOL        isCity;         //用于判断是否选择了城市
    BOOL        isMendian;      //用于判断是否选择了门店

}

@end

@implementation StarSelectCityViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    langSetting = [CVLocalizationSetting sharedInstance];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"顾客点评"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    for (int i=0; i<2; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(10, i%5*90+30, ScreenWidth-20, 60);
        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setTag:100+i];
        button.layer.borderColor=selfborderColor.CGColor;
        button.layer.borderWidth=0.5f;
        button.layer.cornerRadius=3;
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backGround addSubview:button];
        
        UIImageView *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
        [button addSubview:imageViewLeft];
        
        UILabel  *lblLeft=[[UILabel  alloc]initWithFrame:CGRectMake(30, 20, 70, 20)];
        lblLeft.font=[UIFont systemFontOfSize:17];
        lblLeft.backgroundColor=[UIColor clearColor];
        [button addSubview:lblLeft];
        
        UILabel  *lblright=[[UILabel  alloc]initWithFrame:CGRectMake(button.frame.size.width-90, 20, 70, 20)];
        lblright.font=[UIFont systemFontOfSize:17];
        lblright.backgroundColor=[UIColor clearColor];
        lblright.tag = 200+i;
        lblright.textAlignment = NSTextAlignmentCenter;
        [button addSubview:lblright];
        
        UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-20, 20, 20, 20)];
        [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
        [button addSubview:imgJianTou];
        
        switch (i)
        {
            case 0:
            {
                lblLeft.text=[langSetting localizedString:@"city"];
                lblright.text=[langSetting localizedString:@"Select City"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
            }
                break;
            case 1:
            {
                lblLeft.text=[langSetting localizedString:@"stores"];
                lblright.text=[langSetting localizedString:@"Select Stores"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_shop.png"]];
            }
                break;
            default:
                break;
        }
    }
    
    UIButton  *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if(VIEWHRIGHT==44.0)
    {
        nextButton.frame=CGRectMake(10, 250, ScreenWidth-20, 30);
    }
    else
    {
        nextButton.frame=CGRectMake(10, 250, ScreenWidth-20, 30);
    }
    [nextButton setTitle:[langSetting localizedString:@"Next step"] forState:UIControlStateNormal];
    [nextButton setTag:1001];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:nextButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMenDian:) name:@"ChangeAddNotification" object:nil];
}

-(void)AddMenDian:(NSNotification *)notification{
    dicStore =(NSDictionary *)[notification object];
    NSString *str = [dicStore objectForKey:@"firmdes"];
    UILabel *lblMenDian = (UILabel *)[self.view viewWithTag:201];
    lblMenDian.text = str;
    lblMenDian.textAlignment = NSTextAlignmentRight;
    lblMenDian.frame = CGRectMake(100, 20, 190, 20);
    isMendian=YES;
    
}

-(void)ButtonClick:(UIButton *)button
{
    if (button.tag == 100) {  //城市
        typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }else if (button.tag == 101){//门店
        if (strCityCode == nil) {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"请选择城市" delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];//[langSetting localizedString:@"City code is empty"]
                [alert show];
            });
            
        }else{
            OutletViewController *outlet = [[OutletViewController alloc] init];
            outlet.cityCode = strCityCode;
            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:outlet];
            nvc.navigationBar.hidden=YES;
            nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            //            [self.navigationController pushViewController:outlet animated:YES];
            [self presentViewController:nvc animated:YES completion:^{
                
            }];
            
        }
        
    }
}

-(void)nextButtonClick
{
    //城市
    UILabel *lblCity = (UILabel *)[self.view viewWithTag:200];
    if ([lblCity.text isEqualToString:[langSetting localizedString:@"Select City"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select City"]];
        return;
    }
    //门店
    UILabel *lblMenDian = (UILabel *)[self.view viewWithTag:201];
    if ([lblMenDian.text isEqualToString:[langSetting localizedString:@"Select Stores"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select Stores"]];
        return;
    }
    StarRatingViewController *star=[[StarRatingViewController alloc]init];
    [star setStoreMessage:strCityCode];
    [self.navigationController pushViewController:star animated:YES];
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

#pragma mark - registerViewControllerDelegate
//城市
-(void)setpro:(changeCity *)pro
{
    UILabel *lblPro = (UILabel *)[self.view viewWithTag:200];
    lblPro.text=pro.selectprovice;
    strCityCode = pro.selectproviceId;
    
    //城市
    UILabel *lblCity = (UILabel *)[self.view viewWithTag:200];
    
    //门店，如果城市改变，门店清空
    UILabel *lblStore = (UILabel *)[self.view viewWithTag:201];
    if (![lblCity.text isEqualToString:strCity]) {
        lblStore.text=[langSetting localizedString:@"Select Stores"];
        isMendian=NO;
    }
    
    if (strCity == nil) {
        if ([_dataCity count] > 0) {
            lblCity.text= [_dataCity objectAtIndex:1];
            strCityCode = [_dataCityCode objectAtIndex:1];
        }
    }else{
        lblCity.text= strCity;
    }
    isCity=YES;
}


@end
