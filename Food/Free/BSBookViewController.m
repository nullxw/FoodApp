//
//  BSSearchViewController.m
//  BookSystem-iPhone
//
//  Created by Stan Wu on 12-11-25.
//  Copyright (c) 2012年 Stan Wu. All rights reserved.
//

#import "BSBookViewController.h"
#import "DataProvider.h"
#import "BSBookCell.h"
#import "PackageViewController.h"
#import "SearchCoreManager.h"
#import "LeftClassTableView.h"
#import "OrderViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "hotTableView.h"
#import "OrderDetailViewController.h"
#import "FreeClickViewController.h"
#import "WebImageView.h"

@interface BSBookViewController ()

@end

@implementation BSBookViewController
@synthesize aryResult,strPriceKey,strUnitKey,aryAddition;
@synthesize searchByName,tfInput,contactDic,searchBar,dicInfo;

static bool boolSearch = NO;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    langSetting = [CVLocalizationSetting sharedInstance];
    aryCell = [[NSMutableArray alloc] init];
    [self getTypeFoodList:@"-1"]; //页面初始化的时候加载所有的菜品
    
    //全部菜品按钮
    butHot = [UIButton buttonWithType:UIButtonTypeCustom];
    [butHot setBackgroundImage:[UIImage imageNamed:@"Order_butBgW.png"] forState:UIControlStateNormal];
    boHot = NO;
    [butHot setTitle:[langSetting localizedString:@"All Food"] forState:UIControlStateNormal];
    [butHot setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [butHot addTarget:self action:@selector(hotClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butHot];
    
    //热门菜品按钮
    butAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [butAll setBackgroundImage:[UIImage imageNamed:@"Order_butBg.png"] forState:UIControlStateNormal];
    boAll = YES;
    [butAll setTitle:[langSetting localizedString:@"hot Food"] forState:UIControlStateNormal];
    [butAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butAll addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butAll];
    
    //搜索按钮
    butSerachFood = [UIButton buttonWithType:UIButtonTypeCustom];
    [butSerachFood setImage:[UIImage imageNamed:@"Order_search.png"] forState:UIControlStateNormal];
    [butSerachFood addTarget:self action:@selector(buttonSerachClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butSerachFood];
    
    //菜品table
    tvResult = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tvResult.delegate = self;
    tvResult.dataSource = self;
    tvResult.allowsSelection = NO;
    [self.view addSubview:tvResult];
    
    //添加tableView单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tvResult addGestureRecognizer:tap];
    
    //中间分割线
    imgSeparator = [[UIImageView alloc] init];
    UIImage *img11 = [UIImage imageNamed:@"Order_search.png"];
    CGFloat top1 = 0; // 顶端盖高度
    CGFloat bottom1 = 1 ; // 底端盖高度
    CGFloat left1 = 0; // 左端盖宽度
    CGFloat right1 = 1; // 右端盖宽度
    UIEdgeInsets insets1 = UIEdgeInsetsMake(top1, left1, bottom1, right1);
    UIImage *imgR1 = [img11 resizableImageWithCapInsets:insets1];
    [imgSeparator setImage:imgR1];
    [self.view addSubview:imgSeparator];
    
    //搜索的背景视图
    imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imgv setImage:[UIImage imageNamed:@"Order_padbg.png"]];
    imgv.userInteractionEnabled = YES;
    imgv.hidden = YES;
    
    [self.view addSubview:imgv];
    
    //关闭键盘按钮
    btnKeyBoard = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_paddown.png"] forState:UIControlStateNormal];
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_paddownsel.png"] forState:UIControlStateHighlighted];
    [btnKeyBoard sizeToFit];
    btnKeyBoard.frame = CGRectMake(280, 10, 35, 32);
    [btnKeyBoard addTarget:self action:@selector(updownClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgv addSubview:btnKeyBoard];
    
    //搜索控件
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 310.0f, 44.0f)];
    self.searchBar.frame = CGRectMake(10, 10, 260, 32);
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.backgroundColor=[UIColor clearColor];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"Order_padbg.png"]];
	searchBar.translucent=YES;
	self.searchBar.placeholder=[langSetting localizedString:@"Search"];
	self.searchBar.delegate = self;
	self.searchBar.barStyle=UIBarStyleDefault;
    [imgv addSubview:self.searchBar];
    
    //底部视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kbottomColor;
    [self.view addSubview:bottomView];
    
    lblCount = [[UILabel alloc] init];
    lblCount.textColor = [UIColor redColor];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.font = [UIFont systemFontOfSize:12.0f];
    lblCount.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lblCount];
    
    lblTotal = [[UILabel alloc] init];
    lblTotal.textColor = [UIColor redColor];
    lblTotal.backgroundColor = [UIColor clearColor];
    lblTotal.font = [UIFont systemFontOfSize:12.0f];
    lblTotal.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lblTotal];
    
    
    //我的菜单
    imgMenu = [[UIImageView alloc] init];
    [imgMenu setImage:[UIImage imageNamed:@"Order_myorder.png"]];
    [self.view addSubview:imgMenu];
    imgMenu.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrdered)];
    [imgMenu addGestureRecognizer:singleTap1];
    
    //头部导航条
    navigationBarView *nvc;
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) andTitle:[langSetting localizedString:@"Menu"]];
        
        tvResult.frame = CGRectMake(kLeftTableWidth, 64+30, ScreenWidth-kLeftTableWidth, ScreenHeight-44-20-30-30);
        imgSeparator.frame = CGRectMake(kLeftTableWidth-2, 64+30, 2, ScreenHeight-44-20);
        imgMenu.frame = CGRectMake(ScreenWidth-120, ScreenHeight-30, 120, 30);
        
        lblCount.frame = CGRectMake(0, ScreenHeight-27, 100, 25);
        bottomView.frame = CGRectMake(0, ScreenHeight-30, ScreenWidth, 30);
        imgv.frame = CGRectMake(0, 64+30, ScreenWidth, 30);
        butHot.frame = CGRectMake(0, 64, ScreenWidth/2, 33);
        butAll.frame = CGRectMake(ScreenWidth/2, 64, ScreenWidth/2, 33);
        butSerachFood.frame = CGRectMake(0, 64+30, kLeftTableWidth, 30);
        lblTotal.frame = CGRectMake(90, ScreenHeight-27, 100, 25);
    }else{
        nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) andTitle:[langSetting localizedString:@"Menu"]];
        
        butHot.frame = CGRectMake(0, 44, ScreenWidth/2, 33);
        butAll.frame = CGRectMake(ScreenWidth/2, 44, ScreenWidth/2, 33);
        butSerachFood.frame = CGRectMake(0, 44+30, kLeftTableWidth, 30);
        tvResult.frame = CGRectMake(kLeftTableWidth, 44+30, ScreenWidth-kLeftTableWidth, ScreenHeight-44-30-30-20);
        imgSeparator.frame = CGRectMake(kLeftTableWidth-2, 44+30, 2, ScreenHeight-44);
        
        imgMenu.frame = CGRectMake(ScreenWidth-120, ScreenHeight-30-20, 120, 30);
        lblCount.frame = CGRectMake(0, ScreenHeight-27-20, 100, 25);
        bottomView.frame = CGRectMake(0, ScreenHeight-30-20, ScreenWidth, 30);
        imgv.frame = CGRectMake(0, 44+30, ScreenWidth, 30);
        lblTotal.frame = CGRectMake(90, ScreenHeight-27-20, 100, 25);
    }
    
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    //动画  暂时没用
    butMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img1 = [UIImage imageNamed:@"money"];
    CGFloat top = 1; // 顶端盖高度
    CGFloat bottom = 41 ; // 底端盖高度
    CGFloat left = 20; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *imgR = [img1 resizableImageWithCapInsets:insets];
    [butMenu setBackgroundImage:imgR forState:UIControlStateNormal];
    butMenu.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    butMenu.tag = 55;
    butMenu.hidden = YES;
    
    allPriceLable = [[RTLabel alloc] init];
    allPriceLable.textColor = [UIColor whiteColor];
    allPriceLable.backgroundColor = [UIColor clearColor];
    allPriceLable.font = [UIFont systemFontOfSize:12.0f];
    allPriceLable.hidden = YES;
    allPriceLable.userInteractionEnabled = YES;
    
    [self addCount];//计算总价格
    
    //类别改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"ChangeTypeNotification" object:nil];
    
    //刷新Table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadBookTableNotification" object:nil];

    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - actions
//返回事件
-(void)navigationBarViewbackClick
{
    if([DataProvider sharedInstance].isReserveis)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-6] animated:YES];
        [self cancelRequest];//取消图片请求
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    [self cancelRequest];//取消图片请求
    }
}

-(void)dealloc
{
//    [self cancelRequest];//取消图片请求
}

//键盘显示 布局改变
-(void)keyboardWillShow
{
    btnKeyBoard.selected = NO;
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_paddown.png"] forState:UIControlStateNormal];
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_paddownsel.png"] forState:UIControlStateHighlighted];
    
}

//键盘隐藏  布局改变
-(void)keyboardWillHide
{
    btnKeyBoard.selected = YES;
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_padup.png"] forState:UIControlStateNormal];
    [btnKeyBoard setImage:[UIImage imageNamed:@"Order_padupsel.png"] forState:UIControlStateHighlighted];
}


//热门菜品
-(void)hotClick{
    if (boHot) {
        boHot = NO;
        [butHot setBackgroundImage:[UIImage imageNamed:@"Order_butBgW.png"] forState:UIControlStateNormal];
        [butHot setTitle:[langSetting localizedString:@"All Food"] forState:UIControlStateNormal];
        [butHot setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        boAll = YES;
        [butAll setBackgroundImage:[UIImage imageNamed:@"Order_butBg.png"] forState:UIControlStateNormal];
        [butAll setTitle:[langSetting localizedString:@"hot Food"] forState:UIControlStateNormal];
        [butAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        imgSeparator.hidden = NO;
        leftClass.hidden = NO;
        tvResult.hidden = NO;
        tvHot.hidden = YES;
        butSerachFood.hidden = NO;
        
    }else{
        [self hideSerach]; //隐藏搜索
        boHot = YES;
        [butHot setBackgroundImage:[UIImage imageNamed:@"Order_butBg.png"] forState:UIControlStateNormal];
        [butHot setTitle:[langSetting localizedString:@"All Food"] forState:UIControlStateNormal];
        [butHot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        boAll = NO;
        [butAll setBackgroundImage:[UIImage imageNamed:@"Order_butBgW.png"] forState:UIControlStateNormal];
        [butAll setTitle:[langSetting localizedString:@"hot Food"] forState:UIControlStateNormal];
        [butAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        imgSeparator.hidden = YES;
        leftClass.hidden = YES;
        tvResult.hidden = YES;
        tvHot.hidden = NO;
        butSerachFood.hidden = YES;
    }
}

//全部菜品
-(void)allClick{
    if (boAll) {
        [self hideSerach]; //隐藏搜索
        boAll = NO;
        [butAll setBackgroundImage:[UIImage imageNamed:@"Order_butBgW.png"] forState:UIControlStateNormal];
        [butAll setTitle:[langSetting localizedString:@"hot Food"] forState:UIControlStateNormal];
        [butAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        boHot = YES;
        [butHot setBackgroundImage:[UIImage imageNamed:@"Order_butBg.png"] forState:UIControlStateNormal];
        [butHot setTitle:[langSetting localizedString:@"All Food"] forState:UIControlStateNormal];
        [butHot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        imgSeparator.hidden = YES;
        leftClass.hidden = YES;
        tvResult.hidden = YES;
        tvHot.hidden = NO;
        butSerachFood.hidden = YES;
    }else{
        boAll = YES;
        [butAll setBackgroundImage:[UIImage imageNamed:@"Order_butBg.png"] forState:UIControlStateNormal];
        [butAll setTitle:[langSetting localizedString:@"hot Food"] forState:UIControlStateNormal];
        [butAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        boHot = NO;
        [butHot setBackgroundImage:[UIImage imageNamed:@"Order_butBgW.png"] forState:UIControlStateNormal];
        [butHot setTitle:[langSetting localizedString:@"All Food"] forState:UIControlStateNormal];
        [butHot setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        imgSeparator.hidden = NO;
        leftClass.hidden = NO;
        tvResult.hidden = NO;
        tvHot.hidden = YES;
        butSerachFood.hidden = NO;
    }
    
}

//刷新TableView，重新计算价格
-(void)reloadTable{
    [tvResult reloadData];
    [self addCount];
}

//搜索
-(void)serach{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    self.contactDic = dic;
    
    NSMutableArray *nameIDArray = [[NSMutableArray alloc] init];
    self.searchByName = nameIDArray;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    searchByResult = resultArray;
    
    NSNumber *localID = 0;
    NSString *name,*itcope;
    int i = 0;
    for (NSMutableDictionary *dic in aryResult) {
        localID = [NSNumber numberWithInt:i];
         name = [dic objectForKey:@"pdes"];
        itcope = [dic objectForKey:@"pitcode"];
        if (!name) {
            name = [dic objectForKey:@"des"];
            itcope = [dic objectForKey:@"id"];
        }
        [[SearchCoreManager share] AddContact:localID name:name phone:nil];
        [self.contactDic setObject:itcope forKey:localID];
        i++;
    }
}

//已点菜品事件
- (void)showOrdered{
    bs_dispatch_sync_on_main_thread(^{
        OrderDetailViewController *vcOrder = [[OrderDetailViewController alloc] init];
        vcOrder.dicInfo = dicInfo;
        [self.navigationController pushViewController:vcOrder animated:YES];
        
        [self cancelRequest];//取消图片请求
    });
    
}

//点击搜索按钮事件
-(void)buttonSerachClicked:(UIButton *)btn{
    if (boolSearch) {
        [self hideSerach];
    }else{
        [self showSerach];
    }
}

//隐藏搜索
-(void)hideSerach{
    [UIView animateWithDuration:0.2 animations:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            imgv.hidden = YES;
            butSerachFood.frame = CGRectMake(0, 0+64+30, kLeftTableWidth-2, 30);
            leftClass.frame = CGRectMake(0, 30+64+30, kLeftTableWidth-2, ScreenHeight-30-64-30-30);
            tvResult.frame = CGRectMake(kLeftTableWidth, 64+30, ScreenWidth-kLeftTableWidth, ScreenHeight-64-30-30);
            [self.searchBar resignFirstResponder];
            boolSearch = NO;
        }else{
            imgv.hidden  = YES;
            butSerachFood.frame = CGRectMake(0, 0+44+30, kLeftTableWidth-2, 30);
            leftClass.frame = CGRectMake(0, 30+44+30, kLeftTableWidth-2, ScreenHeight-44-112);
            tvResult.frame = CGRectMake(kLeftTableWidth, 44+30, ScreenWidth-kLeftTableWidth, ScreenHeight-44-30-30);
            [self.searchBar resignFirstResponder];
            boolSearch = NO;
        }
    } completion:^(BOOL finished) {
        
    }];
    }

//显示搜索
-(void)showSerach{
    [UIView animateWithDuration:0.2 animations:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            imgv.hidden = NO;
            butSerachFood.frame = CGRectMake(0, 50+64+30, kLeftTableWidth-2, 30);
            imgv.frame = CGRectMake(0, 64+30, ScreenWidth, 50);
            tvResult.frame = CGRectMake(kLeftTableWidth, 50+64+30, ScreenWidth-kLeftTableWidth, self.view.frame.size.height-50-64-30-40);
            leftClass.frame = CGRectMake(0, 50+30+64+30, kLeftTableWidth-2, self.view.frame.size.height-50-30-64-30-30);
            boolSearch = YES;
        }else{
            imgv.hidden = NO;
            butSerachFood.frame = CGRectMake(0, 50+44+30, kLeftTableWidth-2, 30);
            imgv.frame = CGRectMake(0, 44+30, ScreenWidth, 50);
            tvResult.frame = CGRectMake(kLeftTableWidth, 50+44+30, ScreenWidth-kLeftTableWidth, self.view.frame.size.height-50-44-30-40);
            leftClass.frame = CGRectMake(0, 30+44+30+50, kLeftTableWidth-2, ScreenHeight-44-112-50);
            boolSearch = YES;
        }

    } completion:^(BOOL finished) {
        
    }];
  }

//搜索框旁边的隐藏键盘按钮
- (void)updownClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    NSString *str = btn.selected?@"up":@"down";
    if (btn.selected){
        [self.searchBar resignFirstResponder];
    }else{
        [self.searchBar becomeFirstResponder];
    }
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Order_pad%@.png",str]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Order_pad%@sel.png",str]] forState:UIControlStateHighlighted];
    
    [self.searchBar resignFirstResponder];
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
    if (allPrice > 0) {
        NSString *strTotal = [NSString stringWithFormat:[langSetting localizedString:@"money:%.2f"],allPrice];
        lblTotal.text = strTotal;
        NSString *strCount = [NSString stringWithFormat:[langSetting localizedString:@"food:%d"],allTotal];
        lblCount.text = strCount;
        lblTotal.hidden = NO;
        lblCount.hidden = NO;
    }else{
        NSString *strTotal = [NSString stringWithFormat:[langSetting localizedString:@"money:%.2f"],allPrice];
        lblTotal.text = strTotal;
        NSString *strCount = [NSString stringWithFormat:[langSetting localizedString:@"food:%d"],allTotal];
        lblCount.text = strCount;
        lblTotal.hidden = YES;
        lblCount.hidden = YES;
    }
    return allPrice;
}

//取消图片请求
-(void)cancelRequest{
    for (BSBookCell *cell in aryCell) {
        WebImageView *webImg = cell.recommendImage;
        [webImg cancelRequest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FoodResultCell";
    BSBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSBookCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    if ([self.searchBar.text length] <= 0) {//判断是否是搜索
        NSMutableArray *aryCount = [NSMutableArray array];
        for (NSMutableDictionary *dic in aryResult) {
            if ([[dic objectForKey:@"grpStr"] isEqualToString:[[classArray objectAtIndex:indexPath.section] objectForKey:@"des"]]) {//根据类别放在不同的section中
                [aryCount addObject:dic];
            }
        }
        cell.dicInfo = [aryCount objectAtIndex:indexPath.row];
        cell.cellImageClick=^(NSDictionary *dict)
        {
            PackageViewController *pack = [[PackageViewController alloc] init];
            [pack setDicInfo:dict];
            [self.navigationController pushViewController:pack animated:YES];

        };
        return cell;
    }
    cell.dicInfo = [searchByResult objectAtIndex:indexPath.row];

    [aryCell addObject:cell];
    return cell;
}

#pragma cellDelegate
-(void)cellClick:(UITextField *)textFiled andCell:(BSBookCell *)cell andDict:(NSMutableDictionary *)dicInfo
{
    if([cell isKindOfClass:[self class]])
    {
        [textFiled resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *aryCount = [NSMutableArray array];
    if ([self.searchBar.text length] <= 0) {//判断是否是搜索
        for (NSDictionary *dic in aryResult) {
            if ([[dic objectForKey:@"grpStr"] isEqualToString:[[classArray objectAtIndex:section] objectForKey:@"des"]]) {
                [aryCount addObject:dic];
            }
        }
        return [aryCount count];
    }else{
        return [searchByResult count];
        
    }
}


//section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     if ([self.searchBar.text length] <= 0) {
         NSLog(@"%@",classArray);
          return [classArray count];
     }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headerTitle;
    if ([self.searchBar.text length] <= 0) {
        headerTitle = [[classArray objectAtIndex:section] objectForKey:@"des"];
    }else{
        int count = [searchByResult count] ;
        headerTitle = [NSString stringWithFormat:@"共搜索到%d个",count];
    }
    return headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - UISearchBarDelegate
//如果输入框里面的值改变开始重新搜索
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:searchByName phoneMatch:nil];
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
     searchByResult = [NSMutableArray array];
    for (int i=0; i<[searchByName count]; i++) {
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        localID = [self.searchByName objectAtIndex:i];
        if ([self.searchBar.text length]) {
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
        //按照筛选出得itcode查出菜品放入数组中
        NSString *itcode = [self.contactDic objectForKey:localID];
        for (NSMutableDictionary *dic in aryResult) {
            if ([[dic objectForKey:@"pitcode"] isEqualToString:itcode] | [[dic objectForKey:@"id"] isEqualToString:itcode]) {
                [searchByResult addObject:dic];
                break;
            }
        }
    }
    [tvResult reloadData];
}




#pragma mark 类别的通知
//按照类别查询调用的通知方法
-(void)refreshTable:(NSNotification *)notification{
    NSString *strClass = (NSString *)notification.object;
   [self getTypeFoodList:strClass];
}

//查询所有菜品
- (void )getTypeFoodList:(NSString *)strClass{
    if ([strClass isEqualToString:@"-1"]) { //首次加载执行
        [SVProgressHUD showProgress:-1 status:@"" maskType:SVProgressHUDMaskTypeClear];
        [NSThread detachNewThreadSelector:@selector(getFoodList) toTarget:self withObject:nil];
    }else{//点击类别执行
        if ([self.searchBar.text length] <= 0) {
            int z = 0;
            for (NSDictionary *dic in aryResult) {
                if ([[dic objectForKey:@"grpStr"] isEqualToString:strClass]) {
                    z++;
                }
            }
            if (z > 0) { //判断该类别下是否存在菜品，没有菜品不跳转
                int a = [self getIndex:strClass];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:a];
                [tvResult scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

//获取菜品、套餐、类别
-(void)getFoodList{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        classArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[[dicInfo objectForKey:@"Store"] objectForKey:@"firmid"] forKey:@"firmId"];
        //获取套餐
        NSDictionary *dicPack = [dp getPackList:dic];
        if ([[dicPack objectForKey:@"Result"] boolValue]) {
            [SVProgressHUD dismiss];
            aryPack = [NSMutableArray arrayWithArray:[dicPack objectForKey:@"Message"]];
        }else{
            //        [SVProgressHUD showErrorWithStatus:@"获取类别失败"];
        }
        
        //获取类别
        NSDictionary *dicResult = [dp getClassList:dic];
        if ([[dicResult objectForKey:@"Result"] boolValue]) {
            [SVProgressHUD dismiss];
            if ([aryPack count] > 0) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"套餐",@"des", nil];
                [classArray addObject:dic];
            }
            [classArray addObjectsFromArray:[dicResult objectForKey:@"Message"]];
        }else{
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get the category"]];
        }
        
        //获取菜品
        NSDictionary *dicFood = [dp getFoodList:dic];
        if ([[dicResult objectForKey:@"Result"] boolValue]) {
            [SVProgressHUD dismiss];
            aryResult = [NSMutableArray arrayWithArray:[dicFood objectForKey:@"Message"]];
            if ([aryPack count] >0) {
                [aryResult addObjectsFromArray:aryPack];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get food"]];
        }
        //获取热门菜品
        NSDictionary *dicHot = [dp getHotFoodList:dic];
        if ([[dicHot objectForKey:@"Result"] boolValue]) {
            [SVProgressHUD dismiss];
            aryHot = [NSMutableArray arrayWithArray:[dicHot objectForKey:@"Message"]];
        }else{
//            [SVProgressHUD showErrorWithStatus:@"获取热门菜品失败"];
        }
        //数据加载完成执行
//        bs_dispatch_sync_on_main_thread(^{
            [tvResult reloadData];
            [self serach];//给第三方搜索插件赋值
            
            //加载类别列表
            leftClass = [[LeftClassTableView alloc] initWithFrame:CGRectZero info:classArray];
            
            //加载热门菜品列表
            tvHot = [[hotTableView alloc] initWithFrame:CGRectZero info:aryHot];
            tvHot.hidden = YES;
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                leftClass.frame = CGRectMake(0, 30+64+30, kLeftTableWidth-2, ScreenHeight-30-64-30-30);
                tvHot.frame = CGRectMake(0, 64+30, ScreenWidth, ScreenHeight-44-20-30-30);
            }else{
                leftClass.frame = CGRectMake(0, 30+44+30, kLeftTableWidth-2, ScreenHeight-44-112);
                tvHot.frame = CGRectMake(0, 44+30, ScreenWidth, ScreenHeight-44-30-30-20);
            }
            [self.view addSubview:leftClass];
            [self.view addSubview:tvHot];
            
//        });
    }
}

//获取一个值在数组中的位置
-(int)getIndex:(NSString *)strClass{
    for (int i = 0; i<[classArray count]; i++) {
        NSDictionary *dic = [classArray objectAtIndex:i];
        if ([[dic objectForKey:@"des"] isEqualToString:strClass]) {
            return i;
        }
    }
    return 0;
}

#pragma mark UIScrollViewDelegate Methods
//下拉显示搜索
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    float offset = scrollView.contentOffset.y;
    if (offset < -30) {
        [self showSerach]; //显示搜索
    }
}

#pragma mark  点菜动画

//重写UIGestureRecognizerDelegate种的方法，解决手势和TableView的didSelect方法不能同时调用的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        CGPoint p = [touch locationInView:self.view];
        lx = p.x;
        ly = p.y;
        return NO;
    }
    return  YES;
}

//单击事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    CGPoint p = [tap locationInView:self.view];
    NSLog(@"%f===%f", p.y,p.x);
}

-(void)addToShow:(NSIndexPath *)indexPath cellx:(float)x1 celly:(float)y1{
    
    //声音
    BOOL sound = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] boolValue];
    if (sound) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"addFood" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);
    }
    
    //得到产品信息
    NSDictionary *dic = [aryResult objectAtIndex:indexPath.row];
    addPrice = [[dic valueForKey:@"PRICE"] intValue];
    
    //加入购物车动画效果
    CALayer *transitionLayer = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 1.0;
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodview"]];
    //    transitionLayer.contents = (id)bt.titleLabel.layer.contents;
    transitionLayer.contents = (id)img.layer.contents;
    //    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:bt.titleLabel.bounds fromView:bt.titleLabel];
    transitionLayer.frame = CGRectMake(x1, y1, 20, 20);
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    [CATransaction commit];
    
    //路径曲线
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    CGPoint toPoint = CGPointMake(imgMenu.center.x, imgMenu.center.y+120);
    //    CGPoint toPoint = CGPointMake(0, 0);
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(imgMenu.center.x,transitionLayer.position.y-120)];
    //    [movePath addQuadCurveToPoint:toPoint
    //                     controlPoint:CGPointMake(shopCarBt.center.x,0)];
    //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.7;
    group.animations = [NSArray arrayWithObjects:positionAnimation,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses= NO;
    
    [transitionLayer addAnimation:group forKey:@"opacity"];
    [self performSelector:@selector(addShopFinished:) withObject:transitionLayer afterDelay:0.5f];
}

//加入购物车 步骤2
- (void)addShopFinished:(CALayer*)transitionLayer{
    
    [tvResult reloadData];
    
    allPrice = [self addCount];//计算总价格
   
    transitionLayer.opacity = 0;
        
    //价格上浮的动画效果
//    UILabel *addLabel = (UILabel*)[self.view viewWithTag:66];
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.frame = CGRectMake(150, 424, 79, 21);
    addLabel.opaque = NO;
    addLabel.alpha = 0;
    addLabel.clipsToBounds = YES;
    addLabel.textColor = [UIColor redColor];
    [addLabel setText:[NSString stringWithFormat:@"+%i",addPrice]];
    
    CALayer *transitionLayer1 = [[CALayer alloc] init];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer1.opacity = 1.0;
    transitionLayer1.contents = (id)addLabel.layer.contents;
    transitionLayer1.frame = [[UIApplication sharedApplication].keyWindow convertRect:addLabel.bounds fromView:addLabel];
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer1];
    [CATransaction commit];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(addLabel.frame.origin.x+30, addLabel.frame.origin.y+20)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(addLabel.frame.origin.x+30, addLabel.frame.origin.y)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.3;
    group.animations = [NSArray arrayWithObjects:positionAnimation,opacityAnimation,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.autoreverses= NO;
    [transitionLayer1 addAnimation:group forKey:@"opacity"];
    
}


@end
