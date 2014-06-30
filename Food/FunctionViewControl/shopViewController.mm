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
    BMKMapView          *_mapView;
    BMKSearch           *_search;
    UILabel             *_lblchangeCity;
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    float               _latitude;//经度
    float               _longitude;//纬度

}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"店铺查询"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width,_backGround.frame.size.height)];
    [_mapView setShowsUserLocation:YES];
    
//    用于地理编码和反编码
//    _search = [[BMKSearch alloc]init];
    
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
    
    

}

//位置发生改变时获取当前的经纬度
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        _latitude=userLocation.location.coordinate.latitude;
        _longitude=userLocation.location.coordinate.longitude;
	}
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
	if (_latitude && _longitude) {
		pt = (CLLocationCoordinate2D){_latitude, _longitude};
	}
	BOOL flag = [_search reverseGeocode:pt];
	if (flag) {
		NSLog(@"ReverseGeocode search success.");
        
	}
    else{
        NSLog(@"ReverseGeocode search failed!");
    }

	
}

-(void)changeButtonClick:(UIButton *)button
{
 
    if(button.tag==101)
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
-(void)setpro:(changeCity *)pro
{
    _lblchangeCity.text = pro.selectprovice;
    [DataProvider sharedInstance].selectCity=pro;
    shopListViewController *shopList=[[shopListViewController alloc]init];
    [self.navigationController pushViewController:shopList animated:YES];
}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
