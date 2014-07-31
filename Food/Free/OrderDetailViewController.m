//
//  OrderDetailViewController.m
//  Food
//
//  Created by dcw on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderViewController.h"
#import "OrderDetailCell.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookTableNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotTableNotification" object:nil];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    langSetting = [CVLocalizationSetting sharedInstance];
	offSet = 0;
    aryOrder = [[DataProvider sharedInstance] orderedFood];
    
    //最上面视图
    viewUpUp = [[UIView alloc] init];
    viewUpUp.backgroundColor = kgrayColor;
    [self.view addSubview:viewUpUp];
    
    //上面视图
    viewUp = [[UIView alloc] init];
    viewUp.layer.masksToBounds = YES;
    viewUp.layer.borderWidth  =0.5;
    viewUp.layer.cornerRadius = 10;
    viewUp.layer.borderColor= [[UIColor grayColor] CGColor];
    [self.view addSubview:viewUp];
    //中间视图
    viewDown = [[UIView alloc] init];
    viewDown.layer.masksToBounds = YES;
    viewDown.layer.borderWidth  =0.5;
    viewDown.layer.cornerRadius = 10;
    viewDown.layer.borderColor= [[UIColor grayColor] CGColor];
    [self.view addSubview:viewDown];
    
    //底部视图
    viewBottom = [[UIView alloc] init];
    viewBottom.backgroundColor = kbottomColor;
    [self.view addSubview:viewBottom];
    //表示图
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-15, ScreenHeight-70-100-40) style:UITableViewStylePlain];
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    tvOrder.allowsSelection = NO;
    [viewUp addSubview:tvOrder];
    
    //添加点击table的单机手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickPrice)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [tvOrder addGestureRecognizer:singleTap];
    
    //客户留言
    lblAddition = [[UITextView alloc] init];
    lblAddition.delegate = self;
    lblAddition.frame = CGRectMake(5, 5, ScreenWidth-15, 60);
    lblAddition.textColor = [UIColor blackColor];
    lblAddition.backgroundColor = [UIColor clearColor];
    lblAddition.font = [UIFont fontWithName:@"Arial" size:14.0];
    NSString *strAddition = [[NSUserDefaults standardUserDefaults] objectForKey:@"addition"];
    if ([strAddition isEqualToString:@""]) {
        lblAddition.text = [langSetting localizedString:@"Special requirements"];
    }else{
        lblAddition.text = strAddition;
    }
    [viewDown addSubview:lblAddition];
    
    lblCount = [[UILabel alloc] init];
    lblCount.textColor = [UIColor redColor];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.font = [UIFont systemFontOfSize:12.0f];
    lblCount.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lblCount];
    
    lblSum = [[UILabel alloc] init];
    lblSum.textColor = [UIColor redColor];
    lblSum.backgroundColor = [UIColor clearColor];
    lblSum.font = [UIFont systemFontOfSize:12.0f];
    lblSum.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lblSum];
    
    //添加最上面视图的按钮
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 170, 20)];
    name.textAlignment=NSTextAlignmentLeft;
    name.text=[langSetting localizedString:@"Food"];
    name.textColor = [UIColor blackColor];
    name.backgroundColor=[UIColor clearColor];
    name.font=[UIFont systemFontOfSize:17];
    [viewUpUp addSubview:name];
    
    UIButton *butClear = [UIButton buttonWithType:UIButtonTypeCustom];
    butClear.frame = CGRectMake(ScreenWidth-155,5, 70, 28);
    [butClear addTarget:self action:@selector(clearFood) forControlEvents:UIControlEventTouchUpInside];
    [butClear setBackgroundImage:[UIImage imageNamed:@"Order_clear.png"] forState:UIControlStateNormal];
    [viewUpUp addSubview:butClear];
    
    UIButton *butAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    butAdd.frame = CGRectMake(ScreenWidth-80,5, 70, 28);
    [butAdd addTarget:self action:@selector(navigationBarViewbackClick) forControlEvents:UIControlEventTouchUpInside];
    [butAdd setBackgroundImage:[UIImage imageNamed:@"Order_addFood.png"] forState:UIControlStateNormal];
    [viewUpUp addSubview:butAdd];
    
    butSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
//    [butSubmit setTitle:@"确认订单" forState:UIControlStateNormal];
    [butSubmit addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
    [butSubmit setBackgroundImage:[UIImage imageNamed:@"Order_order.png"] forState:UIControlStateNormal];
    [self.view addSubview:butSubmit];
    
    navigationBarView *nvc;
   
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        butSubmit.frame = CGRectMake(ScreenWidth-120, ScreenHeight-30, 120, 30);
        lblCount.frame = CGRectMake(5, ScreenHeight-27, 100, 25);
        lblSum.frame = CGRectMake(90, ScreenHeight-27, 100, 25);
        viewUpUp.frame = CGRectMake(0, 64+offSet, ScreenWidth, 40);
        viewUp.frame = CGRectMake(5, 66+40+offSet, ScreenWidth-10, ScreenHeight-66-100-40);
        viewDown.frame = CGRectMake(5, ScreenHeight-97+offSet, ScreenWidth-10, 63);
        viewBottom.frame = CGRectMake(0, ScreenHeight-30+offSet, ScreenWidth-10, 30);

        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:[langSetting localizedString:@"Have food"]];
    }else{
        butSubmit.frame = CGRectMake(ScreenWidth-120, ScreenHeight-30-20, 120, 30);
        lblCount.frame = CGRectMake(5, ScreenHeight-27-20, 100, 25);
        lblSum.frame = CGRectMake(90, ScreenHeight-27-20, 100, 25);
        viewUpUp.frame = CGRectMake(0, 44+offSet, ScreenWidth, 40);
        viewUp.frame = CGRectMake(5, 46+40+offSet, ScreenWidth-10, ScreenHeight-46-120-40);
        viewDown.frame = CGRectMake(5, ScreenHeight-97-20+offSet, ScreenWidth-10, 63);
        viewBottom.frame = CGRectMake(0, ScreenHeight-30-20+offSet, ScreenWidth-10, 30);
        
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:[langSetting localizedString:@"Have food"]];
    }

    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    [self addCount]; //计算总价格
    //刷新Table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadOrderDetailTableNotification" object:nil];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mrak - actions

//键盘显示  布局改变
-(void)keyboardWillShow
{
    offSet = -180;
    [UIView animateWithDuration:0.18 animations:^{
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            viewUpUp.frame = CGRectMake(0, 64+offSet, ScreenWidth, 40);
            viewUp.frame = CGRectMake(5, 66+40+offSet, ScreenWidth-10, ScreenHeight-66-100-40);
            viewDown.frame = CGRectMake(5, ScreenHeight-97+offSet, ScreenWidth-10, 63);
            viewBottom.frame = CGRectMake(0, ScreenHeight-30+offSet, ScreenWidth-10, 30);
        }else{
            viewUpUp.frame = CGRectMake(0, 44+offSet, ScreenWidth, 40);
            viewUp.frame = CGRectMake(5, 46+40+offSet, ScreenWidth-10, ScreenHeight-46-100-40);
            viewDown.frame = CGRectMake(5, ScreenHeight-97+offSet, ScreenWidth-10, 63);
            viewBottom.frame = CGRectMake(0, ScreenHeight-30+offSet, ScreenWidth-10, 30);
        }
    } completion:^(BOOL finished) {
        
    }];
}

//键盘隐藏  布局改变
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.18 animations:^{
        offSet = 0;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            viewUpUp.frame = CGRectMake(0, 64+offSet, ScreenWidth, 40);
            viewUp.frame = CGRectMake(5, 66+40+offSet, ScreenWidth-10, ScreenHeight-66-100-40);
            viewDown.frame = CGRectMake(5, ScreenHeight-97+offSet, ScreenWidth-10, 63);
            viewBottom.frame = CGRectMake(0, ScreenHeight-30+offSet, ScreenWidth-10, 30);
        }else{
            butSubmit.frame = CGRectMake(ScreenWidth-120, ScreenHeight-30-20, 120, 30);
            lblCount.frame = CGRectMake(5, ScreenHeight-27-20, 100, 25);
            lblSum.frame = CGRectMake(90, ScreenHeight-27-20, 100, 25);
            viewUpUp.frame = CGRectMake(0, 44+offSet, ScreenWidth, 40);
            viewUp.frame = CGRectMake(5, 46+40+offSet, ScreenWidth-10, ScreenHeight-46-120-40);
            viewDown.frame = CGRectMake(5, ScreenHeight-97-20+offSet, ScreenWidth-10, 63);
            viewBottom.frame = CGRectMake(0, ScreenHeight-30-20+offSet, ScreenWidth-10, 30);
        }
    } completion:^(BOOL finished) {
        
    }];
}
//计算总价格
-(float)addCount{
     [lblAddition resignFirstResponder];
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
    if (allPrice > 0) {
        NSString *strTotal = [NSString stringWithFormat:[langSetting localizedString:@"money:%.2f"],allPrice];
        lblSum.text = strTotal;
        NSString *strCount = [NSString stringWithFormat:[langSetting localizedString:@"food:%d"],allTotal];
        lblCount.text = strCount;
        lblSum.hidden = NO;
        lblCount.hidden = NO;
    }else{
        NSString *strTotal = [NSString stringWithFormat:[langSetting localizedString:@"money:%.2f"],allPrice];
        lblSum.text = strTotal;
        NSString *strCount = [NSString stringWithFormat:[langSetting localizedString:@"food:%d"],allTotal];
        lblCount.text = strCount;
        lblSum.hidden = YES;
        lblCount.hidden = YES;
        [self clearaddition];
    }
    return allPrice;
}
//跳转到菜单页
-(void)showOrder{
    if ([lblAddition.text isEqualToString:[langSetting localizedString:@"Special requirements"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:lblAddition.text forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    OrderViewController *order = [[OrderViewController alloc] init];
    order.dicInfo = (NSMutableDictionary *)self.dicInfo;
    [self.navigationController pushViewController:order animated:YES];
}

//清空特殊要求
-(void)clearaddition
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addition"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    lblAddition.text=[langSetting localizedString:@"Special requirements"];
}

//清空菜品
-(void)clearFood{
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
    [ary removeAllObjects];
    [dp saveOrders];
    [self addCount];
  
    [tvOrder reloadData];
}

//刷新页面
-(void)reloadTable{
    [tvOrder reloadData];
    [self addCount];
    NSString *strAddition = [[NSUserDefaults standardUserDefaults] objectForKey:@"addition"];
    if ([strAddition isEqualToString:@""]) {
        lblAddition.text = [langSetting localizedString:@"Special requirements"];        
    }else{
        lblAddition.text = strAddition;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//单机tableview的手势
-(void)tapClickPrice{
    [lblAddition resignFirstResponder];
}
#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:[langSetting localizedString:@"Special requirements"]]) {
        textView.text = nil;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:[langSetting localizedString:@"Special requirements"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:@"addition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [lblAddition resignFirstResponder];
    return YES;
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FoodResultCell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
