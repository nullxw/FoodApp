//
//  shopViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "shopViewController.h"
#import "shopListViewController.h"


@implementation shopViewController
{
    UILabel             *_lblchangeCity;
    UILabel             *_lblLocalCity;
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    BOOL                canPush;//是否定位成功可以跳转
    CVLocalizationSetting *    langSetting;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
        langSetting=[CVLocalizationSetting sharedInstance];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Store the query"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    
        
    UIButton *btnCurrentCity=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCurrentCity setBackgroundColor:[UIColor whiteColor]];
    btnCurrentCity.frame=CGRectMake(10, 30, SUPERVIEWWIDTH-20, 60);
    btnCurrentCity.layer.cornerRadius=5.0;
    btnCurrentCity.tag=100;
    btnCurrentCity.layer.borderColor=selfborderColor.CGColor;
    btnCurrentCity.layer.borderWidth=0.5;
    [btnCurrentCity  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_meal.png"]];
    [btnCurrentCity addSubview:imageViewLeft];
    
    UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnCurrentCity.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [btnCurrentCity addSubview:imgJianTou];
    
    UILabel *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:@"当前城市"];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [btnCurrentCity addSubview:lblLeft];
    
    
//    定位成功直接进入地图查看，定位失败必须先选择城市才可查看地图
    NSString *title;
    if([DataProvider sharedInstance].localCity)
    {
        canPush=YES;
        title=[DataProvider sharedInstance].localCity;
    }
    else
    {
        canPush=NO;
        title=@"定位失败";
    }
    
    _lblLocalCity=[[UILabel alloc]init];
    _lblLocalCity.frame=CGRectMake(0, 0, btnCurrentCity.frame.size.width-60, 60);
    [_lblLocalCity setText:title];
    _lblLocalCity.textAlignment=NSTextAlignmentRight;
    _lblLocalCity.backgroundColor=[UIColor clearColor];
    _lblLocalCity.font=[UIFont systemFontOfSize:13];
    [_lblLocalCity setTextColor:[UIColor blackColor]];
    [btnCurrentCity addSubview:_lblLocalCity];
    [_backGround addSubview:btnCurrentCity];
    

    
    
    UIButton *btnSelectCity=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelectCity setBackgroundColor:[UIColor whiteColor]];
    btnSelectCity.frame=CGRectMake(10, 120, SUPERVIEWWIDTH-20, 60);
    btnSelectCity.layer.cornerRadius=5.0;
    btnSelectCity.tag=101;
    btnSelectCity.layer.borderColor=selfborderColor.CGColor;
    btnSelectCity.layer.borderWidth=0.5;
    [btnSelectCity  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_meal.png"]];
    [btnCurrentCity addSubview:imageViewLeft];
    
    imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnCurrentCity.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [btnCurrentCity addSubview:imgJianTou];

    
    [btnSelectCity addSubview:imageViewLeft];
    [btnSelectCity addSubview:imgJianTou];
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:@"城市选择"];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [btnSelectCity addSubview:lblLeft];
    
    _lblchangeCity=[[UILabel alloc]init];
    _lblchangeCity.frame=CGRectMake(0, 0, btnSelectCity.frame.size.width-60, 60);
    [_lblchangeCity setText:@"选择城市"];
    _lblchangeCity.textAlignment=NSTextAlignmentRight;
    _lblchangeCity.backgroundColor=[UIColor clearColor];
    _lblchangeCity.font=[UIFont systemFontOfSize:13];
    [_lblchangeCity setTextColor:[UIColor blackColor]];
    [btnSelectCity addSubview:_lblchangeCity];
    [_backGround addSubview:btnSelectCity];
    
//   刷新定位城市的经纬度通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refushlocal) name:@"refushLocal" object:nil];
    
}


//100：定位成功直接调转   101：定位失败，选择城市后调转
-(void)changeButtonClick:(UIButton *)button
{
    if (button.tag==100)
    {
        
       if(canPush)
       {
           changeCity *change=[[changeCity alloc]init];
           if([_lblLocalCity.text rangeOfString:@"市"].location !=NSNotFound)//判断字符串中是否包含“市”字
           {
              change.selectprovice=[_lblLocalCity.text substringWithRange:NSMakeRange(0, [_lblLocalCity.text length]-1)];
           }
           else
           {
              change.selectprovice=_lblLocalCity.text;
           }
           
           change.selectproviceId=[NSString stringWithFormat:@"0"];
        [DataProvider sharedInstance].selectCity=change;
        shopListViewController *shopList=[[shopListViewController alloc]init];
        [self.navigationController pushViewController:shopList animated:YES];
       }
       else
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[NSString stringWithFormat:@"%@\n%@",[langSetting localizedString:@"Locate failure"],[langSetting localizedString:@"Please select a city"]] delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles: nil];
                alert.tag=10010;
                [alert show];
            });
            
        }
    }
    else if(button.tag==101)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];

    }
}

#pragma mark typeSelectViewViewController代理

//选择城市
-(void)setpro:(changeCity *)pro
{
    if(!canPush)
    {
       _lblLocalCity.text= pro.selectprovice;
        [DataProvider sharedInstance].localCity=pro.selectprovice;
        //如果定位失败，根据选择的城市用于地图定位
    }
    _lblchangeCity.text = pro.selectprovice;
    [DataProvider sharedInstance].selectCity=pro;
   
    shopListViewController *shopList=[[shopListViewController alloc]init];
    [self.navigationController pushViewController:shopList animated:YES];
}

#pragma mark alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10010)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }
}


//在其他定位成功或者选择城市后，将选择的城市赋值给当前的定位城市
-(void)refushlocal
{
    _lblLocalCity.text=[DataProvider sharedInstance].localCity;
}
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
