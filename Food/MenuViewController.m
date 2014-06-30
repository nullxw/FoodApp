//
//  MenuViewController.m
//  Food
//
//  Created by sundaoran on 14-3-28.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

#define SELFVIEWWEATH    self.view.bounds.size.width
#define SELFVIEWHEIGHT      self.view.bounds.size.height
@implementation MenuViewController
{
    UIView *_background;
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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
  

    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    
    _background=[[UIView alloc]initWithFrame:self.view.bounds];
    [_background setBackgroundColor:[UIColor redColor]];
    [imageView addSubview:_background];
    
    for (int i=0; i<8; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(((SELFVIEWWEATH-60)/3+20)*(i%3)+10, 10+(i/3)*((SELFVIEWHEIGHT-144)/3+10),(SELFVIEWWEATH-60)/3 ,(SELFVIEWHEIGHT-144)/3);
        button.tag=i+1000+1;
        button.backgroundColor=[UIColor greenColor];
        [_background addSubview:button];
        
        UILabel *lbltitle=[[UILabel alloc]init];
        lbltitle.frame=CGRectMake(0, button.frame.size.height-20, button.frame.size.width, 20);
        lbltitle.backgroundColor=[UIColor blackColor];
        lbltitle.textAlignment=NSTextAlignmentCenter;
        lbltitle.textColor=[UIColor whiteColor];
        switch (i)
        {
            case 0:
                lbltitle.text=@"在线定位";
                break;
            case 1:
                lbltitle.text=@"优惠信息";
                break;
            case 2:
                lbltitle.text=@"自助点餐";
                break;
            case 3:
                lbltitle.text=@"排队叫号";
                break;
            case 4:
                lbltitle.text=@"会员管理";
                break;
            case 5:
                lbltitle.text=@"店铺查询";
                break;
            case 6:
                lbltitle.text=@"查看地图";
                break;
            case 7:
                lbltitle.text=@"其他设置";
                break;
                
            default:
                break;
        }
        [button addSubview:lbltitle];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
