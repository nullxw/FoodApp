//
//  DetailViewController.m
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "DetailViewController.h"
#import "WebImageView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    CVLocalizationSetting *langSetting;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting =[CVLocalizationSetting sharedInstance];
	UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(5, 44+25, ScreenWidth-10, ScreenHeight-44-25-10);
    v.backgroundColor = [UIColor whiteColor];
//    [v.layer setCornerRadius:10.0];
//    [v.layer setMasksToBounds:YES];
//    v.clipsToBounds = YES;
    [self.view addSubview:v];
    
    imgTop = [[WebImageView alloc] init];
    imgTop.frame = CGRectMake(0, 0, v.frame.size.width, 180);
    [imgTop setImage:[UIImage imageNamed:@"defaultFood.png"]];
    imgTop.backgroundColor = [UIColor clearColor];
    [v addSubview:imgTop];
    
    web = [[UIWebView alloc] init];
    web.scrollView.bounces=NO;
    web.frame = CGRectMake(0, 185, v.frame.size.width, v.frame.size.height-185);
    [v addSubview:web];
    
    //头部导航条
    navigationBarView *nvc;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:[langSetting localizedString:@"Preferential information"]];
    }else{
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:[langSetting localizedString:@"Preferential information"]];
    }
    
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
}
#pragma mark - actions
//返回
-(void)navigationBarViewbackClick
{
//    bs_dispatch_sync_on_main_thread(^{
        [imgTop cancelRequest]; //离开该页时取消图片的异步请求
            [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
//    });

}

- (void)setDicInfo:(NSDictionary *)dic{
    
    if (_dicInfo!=dic){
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        [self showInfo:dic];
    }
}

- (void)showInfo:(NSDictionary *)info{
    [self setImagewurl:info];
    bs_dispatch_sync_on_main_thread(^{
        [web loadHTMLString:[info objectForKey:@"wcontent"] baseURL:nil];
    });
}
-(void)setImagewurl:(NSDictionary *)info
{
    if([DataProvider imageCache:[info objectForKey:@"wurl"]])
    {
        [imgTop setImage:[UIImage imageWithData:[DataProvider imageCache:[info objectForKey:@"wurl"]]]];
    }
    else
    {
        [imgTop setImageURL:[NSURL URLWithString:[info objectForKey:@"wurl"]] andImageBoundName:@"defaultFood.png"];
    }
    
}

-(void)dealloc
{
//    [imgTop cancelRequest]; //离开该页时取消图片的异步请求
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
