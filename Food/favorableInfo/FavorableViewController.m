//
//  FavorableViewController.m
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "FavorableViewController.h"
#import "FavorableCell.h"
#import "DetailViewController.h"
#import "WebImageView.h"

@interface FavorableViewController ()

@end

@implementation FavorableViewController
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
	tvFavorable = [[UITableView alloc] init];
    tvFavorable.delegate = self;
    tvFavorable.dataSource = self;
    
    aryCell = [[NSMutableArray alloc] init];
    
    [self.view addSubview:tvFavorable];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
         tvFavorable.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44-20);
    }else{
        tvFavorable.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
    }
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
        [self cancelRequest];
        [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
//    });
    
}
//获取优惠
-(void)getFavorableByAreaList:(NSString *)firmid{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dic = [dp getFavorableByAreaList:firmid];
        if ([[dic objectForKey:@"Result"] boolValue]) {
            aryResult = [dic objectForKey:@"Message"];
            [tvFavorable reloadData];
             [SVProgressHUD dismiss];
        }else{
            //获取信息失败
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"Message"]];//[langSetting localizedString:@"Failed to get information"]
        }
    }
}

- (void)setFirmid:(NSString *)str{
    
    if (_firmid!=str){
        _firmid = [NSString stringWithString:str];
    }
    if (str){
        [self showInfo:str];
    }
}

-(void)showInfo:(NSString *)firmid{
    //获取优惠
    [SVProgressHUD showProgress:-1 status:nil maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getFavorableByAreaList:) toTarget:self withObject:firmid];
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"favorResultCell";
    FavorableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[FavorableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.dicInfo = [aryResult objectAtIndex:indexPath.row];
    [aryCell addObject:cell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryResult count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    bs_dispatch_sync_on_main_thread(^{
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.dicInfo = [aryResult objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
       
    });
}

//取消图片请求
-(void)cancelRequest{
    for (FavorableCell *cell in aryCell) {
        WebImageView *webImg = cell.imgTop;
        [webImg cancelRequest];
    }
}
-(void)dealloc
{
//    for (FavorableCell *cell in aryCell) {
//        WebImageView *webImg = cell.imgTop;
//        [webImg cancelRequest];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
