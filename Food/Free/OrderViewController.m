//
//  OrderViewController.m
//  Food
//
//  Created by dcw on 14-4-16.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "OrderViewController.h"
#import "orderCell.h"
#import "shareInfoData.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
@synthesize dicInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderDetailTableNotification" object:nil];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aryOrder = [[DataProvider sharedInstance] orderedFood];
    langSetting = [CVLocalizationSetting sharedInstance];
	
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        navigationBarView *nvc = [[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:[langSetting localizedString:@"My menu"]];
        nvc.delegate=self;
        [self.view addSubview:nvc];
    }else{
        navigationBarView *nvc = [[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:[langSetting localizedString:@"My menu"]];
        nvc.delegate=self;
        [self.view addSubview:nvc];
    }
    
    
    //上面视图
    UIView *viewUp = [[UIView alloc] init];
    viewUp.layer.masksToBounds = YES;
    viewUp.layer.borderWidth  =0.5;
    viewUp.layer.cornerRadius = 10;
    viewUp.layer.borderColor= [[UIColor grayColor] CGColor];
    [self.view addSubview:viewUp];
    //下面视图
    UIView *viewDown = [[UIView alloc] init];
    viewDown.backgroundColor = kgrayColor;
    viewDown.layer.masksToBounds = YES;
    viewDown.layer.borderWidth  =0.5;
    viewDown.layer.cornerRadius = 10;
    viewDown.layer.borderColor= [[UIColor grayColor] CGColor];
    [self.view addSubview:viewDown];
    //确认订单按钮
    UIButton *butSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [butSubmit setTitle:[langSetting localizedString:@"Affirm Order"] forState:UIControlStateNormal];
    [butSubmit setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal"] forState:UIControlStateNormal];
    [butSubmit addTarget:self action:@selector(butSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butSubmit];
    //表示图
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-15, ScreenHeight-70-150) style:UITableViewStylePlain];
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    tvOrder.allowsSelection = NO;
    [viewUp addSubview:tvOrder];
    
    //特殊要求标签
    lblAddition = [[UILabel alloc] init];
    lblAddition.frame = CGRectMake(5, 5, 70, 40);
    lblAddition.textColor = [UIColor redColor];
    lblAddition.backgroundColor = [UIColor clearColor];
    lblAddition.font = [UIFont systemFontOfSize:14.0];
    lblAddition.text = [langSetting localizedString:@"Additions:"];
    lblAddition.numberOfLines = 3;
    [viewDown addSubview:lblAddition];
    
    //特殊要求
    lblAdd = [[UILabel alloc] init];
    lblAdd.frame = CGRectMake(75, 5, ScreenWidth-15-75, 40);
    lblAdd.textColor = [UIColor redColor];
    lblAdd.backgroundColor = [UIColor clearColor];
    lblAdd.font = [UIFont systemFontOfSize:14.0];
    lblAdd.numberOfLines = 3;
    [viewDown addSubview:lblAdd];
    
    [viewDown addSubview:lblAddition];
    lblCount = [[UILabel alloc] init];
    lblCount.frame = CGRectMake(5, 55, ScreenWidth/2-5, 40);
    lblCount.textColor = [UIColor redColor];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.font = [UIFont systemFontOfSize:15.0];
    [viewDown addSubview:lblCount];
    
    lblSum = [[UILabel alloc] init];
    lblSum.frame = CGRectMake(ScreenWidth/2-5, 55, ScreenWidth/2-5, 40);
    lblSum.textColor = [UIColor redColor];
    lblSum.backgroundColor = [UIColor clearColor];
    lblSum.font = [UIFont systemFontOfSize:15.0];
    [viewDown addSubview:lblSum];
    
    [self addCount]; //计算总价格
    
    //视图布局
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        viewUp.frame = CGRectMake(5, 70, ScreenWidth-10, ScreenHeight-70-150);
        viewDown.frame = CGRectMake(5, ScreenHeight-145, ScreenWidth-10, 95);
        butSubmit.frame = CGRectMake(5, ScreenHeight-45, ScreenWidth-10, 35);
    }else{
        
        viewUp.frame = CGRectMake(5, 70-20, ScreenWidth-10, ScreenHeight-70+20-150);
        viewDown.frame = CGRectMake(5, ScreenHeight-145-20, ScreenWidth-10, 95);
        butSubmit.frame = CGRectMake(5, ScreenHeight-45-20, ScreenWidth-10, 35);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mrak - actions
//提交按钮
-(void)butSubmitClick{
    DataProvider *dp = [DataProvider sharedInstance];
    if ([dp.orderedFood count] < 1) {
        [SVProgressHUD showErrorWithStatus:@"请选择菜品"];
        return;
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue] && [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
    {
        
        NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        NSString *phone;
        if(dp.isReserveis)
        {
            phone= dp.phoneNum;
        }
        else
        {
            phone= [[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
        }
        [dicInfo setObject:name forKey:@"name"];
        [dicInfo setObject:phone forKey:@"phone"];
        [dicInfo setObject:lblAdd.text forKey:@"remark"];
        
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(send:) toTarget:self withObject:dicInfo];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请先绑定手机号码和用户数据，然后提交"];
    }
   
    }

-(void)send:(NSMutableDictionary *)info
{
    DataProvider *dp=[DataProvider sharedInstance];
    if(dp.isReserveis)
    {
        [info setObject:dp.tableId forKey:@"orderId"];
    }
    else
    {
        [info setObject:@"" forKey:@"orderId"];
    }
    BOOL flag = [dp sendFood:info];
    if (flag) {
        NSMutableArray *ary = [dp orderedFood];
        [ary removeAllObjects];
        [dp saveOrders];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tvOrder reloadData];
        lblAdd.text = @"";
        lblCount.text = @"已点菜品：0";
        lblSum.text = @"金额：0.00";
        [SVProgressHUD dismiss];
        bs_dispatch_sync_on_main_thread(^{
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功\n订单可为您预留15分钟\n超时作废\n请合理安排就餐时间" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        });
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"发送菜品失败"];
    }

}
//计算总价格
-(float)addCount{
    allPrice = 0;
    int allTotal = 0;
    NSMutableArray *aryMutOrder = [[DataProvider sharedInstance] orderedFood];
    for (NSDictionary *dicOrder in aryMutOrder) {
        int total = [[dicOrder objectForKey:@"total"] intValue];
        float price = 0;
        price = [[dicOrder objectForKey:@"price2"] floatValue];
        
        float add = price * total;
        allPrice = allPrice + add;
        allTotal = allTotal + total;
    }
    NSString *strTotal = [NSString stringWithFormat:[langSetting localizedString:@"money:%.2f"],allPrice];
    lblSum.text = strTotal;
    NSString *strCount = [NSString stringWithFormat:[langSetting localizedString:@"food:%d"],allTotal];
    lblCount.text = strCount;
    NSString *strAddition = [[NSUserDefaults standardUserDefaults] objectForKey:@"addition"];
    lblAdd.text = strAddition;
    return allPrice;
}
#pragma mark -uialertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FoodResultCell";
    orderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[orderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.dicInfo = [aryOrder objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryOrder count];
}


//section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    if(section==0)
    {
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 20)];
        name.textAlignment=NSTextAlignmentLeft;
        name.text=[langSetting localizedString:@"Food"];
        name.textColor = [UIColor redColor];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont systemFontOfSize:15];
        [view addSubview:name];
        
        UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(170,0, 70, 20)];
        count.textAlignment=NSTextAlignmentCenter;
        count.text=[langSetting localizedString:@"count"];
        count.textColor = [UIColor redColor];
        count.backgroundColor=[UIColor clearColor];
        count.font=[UIFont systemFontOfSize:15];
        [view addSubview:count];
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(240,0, 70, 20)];
        price.textAlignment=NSTextAlignmentCenter;
        price.text=[langSetting localizedString:@"Price"];
        price.textColor = [UIColor redColor];
        price.backgroundColor=[UIColor clearColor];
        price.font=[UIFont systemFontOfSize:15];
        [view addSubview:price];
        view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
