//
//  PackageViewController.m
//  Food
//
//  Created by dcw on 14-4-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "PackageViewController.h"
#import "PackCell.h"
#import "CVLocalizationSetting.h"
#import "DataProvider.h"
#import "WebImageView.h"

@interface PackageViewController ()

@end

@protocol PackageViewControllerDelegate <NSObject>


@end

@implementation PackageViewController
{
    BOOL   isLook;//是否是从查看菜品详情页面跳转
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//返回事件
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [imgView cancelRequest]; //离开该页时取消图片的异步请求
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    aryPackItem = [[NSArray alloc] init];
    langSetting = [CVLocalizationSetting sharedInstance];
   
	//图片
    imgView = [[WebImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"defaultPack.png"]];
    
    imgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgView];
    
    //列表
    tvPackItem = [[UITableView alloc] init];
    tvPackItem.delegate = self;
    tvPackItem.dataSource = self;
    tvPackItem.allowsSelection = NO;
    tvPackItem.layer.masksToBounds = YES;
    tvPackItem.layer.borderWidth  =0.5;
    tvPackItem.layer.cornerRadius = 10;
    [self.view addSubview:tvPackItem];
    
    navigationBarView *nvc;
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        imgView.frame = CGRectMake(8, 70, ScreenWidth-16, 180);
        tvPackItem.frame = CGRectMake(8, 185+70, ScreenWidth-16, ScreenHeight-70-187);
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:@"套餐详情"];
    }else{
        imgView.frame = CGRectMake(5, 50, ScreenWidth-10, 180);
        tvPackItem.frame = CGRectMake(5, 185+50, ScreenWidth-10, ScreenHeight-50-187);
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:@"套餐详情"];
    }
    
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
}

//点菜调转
- (void)setDicInfo:(NSDictionary *)dic{
    isLook=NO;
    if (_dicInfo!=dic){
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        //加载子菜品
        [NSThread detachNewThreadSelector:@selector(getPackItem:) toTarget:self withObject:dic];
        [self getImage:[dic objectForKey:@"picsrc"]];
//        [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:[dic objectForKey:@"picsrc"]];
    }
}

//产看菜品详情跳转
-(void)setDictInfoByLookorder:(NSDictionary *)dic
{
    isLook=YES;
    if (_dicInfo!=dic){
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        //加载子菜品
        [NSThread detachNewThreadSelector:@selector(getPackItem:) toTarget:self withObject:dic];
        [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:[dic objectForKey:@"smallUrl"]];
    }
}

//获取图片路径
-(void)getImage:(NSString *)url
{
    @autoreleasepool {
        if([DataProvider imageCache:url])
        {
            [imgView setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
            
        }
        else
        {
            [imgView setImageURL:[NSURL URLWithString:url]];
        }
    }
    
    
}

-(void)getPackItem:(NSDictionary *)info{
    
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dic;
        if(isLook)
        {
            dic = [dp getPackItemList:[info objectForKey:@"pubitem"]];
        }
        else
        {
             dic = [dp getPackItemList:[info objectForKey:@"id"]];
        }
        
        if ([[dic objectForKey:@"Result"] boolValue]) {
            aryPackItem = [dic objectForKey:@"Message"];
            [tvPackItem reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    }
}
#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FoodResultCell";
    PackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[PackCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.dicInfo = [aryPackItem objectAtIndex:indexPath.row];
//    cell.textLabel.text = @"1";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryPackItem count];
}


//section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    view.backgroundColor = kgrayColor;
    if(section==0)
    {
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 170, 20)];
        name.textAlignment=NSTextAlignmentLeft;
        name.text=[langSetting localizedString:@"Food"];
        name.textColor = [UIColor redColor];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont systemFontOfSize:15];
        [view addSubview:name];
        
        UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(220,0, 70, 20)];
        count.textAlignment=NSTextAlignmentCenter;
        count.text=[langSetting localizedString:@"count"];
        count.textColor = [UIColor redColor];
        count.backgroundColor=[UIColor clearColor];
        count.font=[UIFont systemFontOfSize:15];
        [view addSubview:count];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
