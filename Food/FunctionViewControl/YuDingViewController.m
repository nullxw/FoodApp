//
//  YuDingViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "YuDingViewController.h"
#import "LookReserveViewController.h"

@interface YuDingViewController ()

@end

@implementation YuDingViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    CVLocalizationSetting   *langSetting;
    
    UITableView         *_tableView;
    NSMutableArray      *_dataArray;
    
    NSMutableArray      *_allDataArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view.
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"My reservation"]];//我的预订
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, _backGround.frame.size.height-VIEWHRIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_backGround addSubview:_tableView];
    

    [self refushOrder];
    
//    添加刷新当前界面的通知
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refushOrder) name:@"refushOrder" object:nil];
}

//请求获取预订账单
-(void)refushOrder
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getOrderMenus) toTarget:self withObject:nil];
}


//请求结果处理
-(void)getOrderMenus
{
    @autoreleasepool
    {
        if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
        {
            //请先绑定手机号码
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
        }
        else
        {
            DataProvider *dp=[DataProvider sharedInstance];
            NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
            {
                [Info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];               
            }
            else
            {
                [Info setObject:@"" forKey:@"userId"];//没用用户id的时候置为空字符串
 
            }
            NSDictionary *dict=[dp getOrderMenus:Info];
            if([[dict objectForKey:@"Result"]boolValue])
            {
                NSArray *dataArray=[[NSArray alloc]initWithArray:[dict objectForKey:@"Message"]];
                _allDataArray=[[NSMutableArray alloc]initWithArray:dataArray];
                _dataArray=[[NSMutableArray alloc]init];
                for (NSDictionary *dict in dataArray)
                {
                    NSString *orderTime=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"dat"],[dict objectForKey:@"datmins"]];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDate *date=[[NSDate alloc]init];
                    date=[[dateFormatter dateFromString:orderTime] dateByAddingTimeInterval:15*60];
                    orderTime=[dateFormatter stringFromDate:date];
                    
                    if([DataProvider compareNowTime:orderTime])
                    {
                        [_dataArray addObject:dict];
                    }
                }
                [_tableView reloadData];
                [SVProgressHUD dismiss];
                if([_dataArray count]==0)
                {
                   bs_dispatch_sync_on_main_thread(^{
                       UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"No reservation record"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                       [alert show];
                   });
                    
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
            }
            
        }
    }
}


-(NSString *)nowTime
{
    NSString *nowtime=@"2014-04-01";
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*24;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"MM"];
    //用[NSDate date]可以获取系统当前时间
    NSString *MM = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dd = [dateFormatter stringFromDate:localeDate];
    nowtime=[NSString stringWithFormat:@"%@-%@-%@",yy,MM,dd];
    
    return nowtime;
}

#pragma mark  uitableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    cell.textLabel.textColor=selfbackgroundColor;
    cell.detailTextLabel.numberOfLines=2;
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%d、%@",indexPath.row+1,[dict objectForKey:@"firmdes"]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"就餐时间：%@ %@\n订单编号：%@",[dict objectForKey:@"dat"],[dict objectForKey:@"datmins"],[dict objectForKey:@"resv"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LookReserveViewController *reserve=[[LookReserveViewController alloc]init];
    [reserve setReserve:[_dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:reserve animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
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


/*
 //请求获取预订账单
 -(void)refushOrder

 //请求结果处理
 -(void)getOrderMenus
 */

@end
