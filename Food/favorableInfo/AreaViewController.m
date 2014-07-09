//
//  AreaViewController.m
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "AreaViewController.h"
#import "AreaCell.h"
#import "FavorableViewController.h"

@interface AreaViewController ()

@end

@implementation AreaViewController
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
    langSetting=[CVLocalizationSetting sharedInstance];
	tvArea = [[UITableView alloc] init];
    tvArea.delegate = self;
    tvArea.dataSource = self;
    
    [self.view addSubview:tvArea];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        tvArea.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44-20);
    }else{
        tvArea.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
    }
    
    //头部导航条
    navigationBarView *nvc;
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:[langSetting localizedString:@"area"]];
    }else{
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:[langSetting localizedString:@"area"]];
    }
    
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    //获取地区
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getArea) toTarget:self withObject:nil];
}

#pragma mark - actions
//返回
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取地区
-(void)getArea{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dic = [dp getArea];
        if ([[dic objectForKey:@"Result"] boolValue]) {
            aryResult = [dic objectForKey:@"Message"];
            [tvArea reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"Message"]];//[langSetting localizedString:@"Failed to get information"]
        }
    }
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"favorResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=@"";
     cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.text = [[aryResult objectAtIndex:indexPath.row] objectForKey:@"area"];
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryResult count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    bs_dispatch_sync_on_main_thread(^{
    
        FavorableViewController *f = [[FavorableViewController alloc] init];
        f.firmid = [[aryResult objectAtIndex:indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:f animated:YES];
        
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
