//
//  queueViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "queueViewController.h"
#import "lineCallNumViewController.h"

@interface queueViewController ()

@end

@implementation queueViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UILabel             *_lblchangeCity;
    BOOL                _selectCity;//是否已经选择城市
    CVLocalizationSetting   *langSetting;
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Line up your turn"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    
    UIButton *changeCity=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeCity setBackgroundColor:[UIColor whiteColor]];
    changeCity.frame=CGRectMake(10, 20, SUPERVIEWWIDTH-20, 60);
    changeCity.layer.cornerRadius=5.0;
    changeCity.tag=101;
    changeCity.layer.borderColor=selfborderColor.CGColor;
    changeCity.layer.borderWidth=0.5;
    [changeCity  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
    [changeCity addSubview:imageViewLeft];
    
     UIImageView  *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(changeCity.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [changeCity addSubview:imgJianTou];
    
     UILabel *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:[langSetting localizedString:@"city"]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [changeCity addSubview:lblLeft];
    
    
    _lblchangeCity=[[UILabel alloc]init];
    _lblchangeCity.frame=CGRectMake(0, 0, changeCity.frame.size.width-60, 60);
    [_lblchangeCity setText:[langSetting localizedString:@"Select City"]];
    _lblchangeCity.textAlignment=NSTextAlignmentRight;
    _lblchangeCity.backgroundColor=[UIColor clearColor];
    _lblchangeCity.font=[UIFont systemFontOfSize:13];
    [_lblchangeCity setTextColor:[UIColor blackColor]];
    [changeCity addSubview:_lblchangeCity];
    [_backGround addSubview:changeCity];
    
    UIButton *tijiao=[UIButton buttonWithType:UIButtonTypeCustom];
    [tijiao setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [tijiao setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    tijiao.frame=CGRectMake(10, changeCity.frame.origin.y+changeCity.frame.size.height+50, SUPERVIEWWIDTH-20, 30);
    [tijiao setTitle:[langSetting localizedString:@"Query"] forState:UIControlStateNormal];
    [tijiao addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:tijiao];

    
}

-(void)nextButtonClick
{
    if(_selectCity)//判断是否选择城市
    {
        lineCallNumViewController *lineView=[[lineCallNumViewController alloc]init];
        [self.navigationController pushViewController:lineView animated:YES];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"You haven't choose city"]];
    }
}

//选择城市
-(void)changeButtonClick:(UIButton *)button
{
    typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
    typeView.delegate=self;
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
    nvc.navigationBar.hidden=YES;
    nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nvc animated:YES completion:^{
        
    }];
}


//typeSelectViewViewControllerDelegate选择的城市结果
-(void)setpro:(changeCity *)pro
{
    _lblchangeCity.text= pro.selectprovice;
    [DataProvider sharedInstance].selectOnlyCity=pro.selectprovice;
    [DataProvider sharedInstance].selectCity=pro;//包含身份名称和编码
    _selectCity=YES;
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
