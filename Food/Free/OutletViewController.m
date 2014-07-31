//
//  RootViewController.m
//  1.FontTableViewDemo
//
//  Created by 周泉 on 13-2-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G开发培训中心. All rights reserved.
//

#import "OutletViewController.h"
#import "Chracter.h"
#import "navigationBarView.h"
#import "DataProvider.h"

@interface OutletViewController ()


@end

@implementation OutletViewController
{
    CGFloat             VIEWHRIGHT;
}
@synthesize cityCode;

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
	NSLog(@"%@",cityCode);
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHRIGHT=64.0;
    }
    else
    {
        VIEWHRIGHT=44.0;
    }

    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, VIEWHRIGHT) andTitle:@"选择门店"];
    nvc.delegate = self;
    [self.view addSubview:nvc];
    
    //获取门店
    aryOutlet = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getStoreByArea) toTarget:self withObject:nil];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame=CGRectMake(0, VIEWHRIGHT, ScreenWidth, ScreenHeight-VIEWHRIGHT);
    _tableView.dataSource = self; // 设置数据源
    _tableView.delegate   = self; // 设置委托
    [self.view addSubview:_tableView];
    
}

//获取门店
-(void)getStoreByArea{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:cityCode,@"area", nil];
        dp.isShop=YES;
        NSDictionary *dic = [dp getStoreByArea:dict];
        if ([[dic objectForKey:@"Result"] boolValue]) {
            aryOutlet = [dic objectForKey:@"Message"];
            
            [SVProgressHUD dismiss];
            if([aryOutlet count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无门店数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                });
                
            }
            else
            {
                
                
                [self getChracter];
            }

            
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取门店失败"];
        }
    }
}

//获取首字母
-(void)getChracter{
    //    NSMutableArray *aryOutlet = [[NSMutableArray alloc] initWithObjects:@"中国",@"山东",@"北京",@"全聚德",@"上海",@"中国",@"山东",@"北京",@"全聚德",@"田庄",@"美国",@"上海",@"上海", nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dicResult in aryOutlet) {
        Chracter *chracter = [[Chracter alloc] init];
        NSString *result = [chracter getFirstChracter:[dicResult objectForKey:@"firmdes"]];
        if ([[dic objectForKey:result] count]>0) {
            NSMutableArray *ary = (NSMutableArray *)[dic objectForKey:result];
            [ary addObject:[dicResult objectForKey:@"firmdes"]];
            [dic setValue:ary forKey:result];
        }else{
            NSMutableArray *ary = [[NSMutableArray alloc] init];
            [ary addObject:[dicResult objectForKey:@"firmdes"]];
            [dic setValue:ary forKey:result];
        }
    }
    
    _dataDic = dic;
    NSArray *keyArray = [NSArray arrayWithArray:[_dataDic allKeys]];
    // 排序
    _keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    bs_dispatch_sync_on_main_thread(^{
        [_tableView reloadData];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyArray count];
} // 表视图当中存在secion的个数，默认是1个

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *data = [_dataDic objectForKey:[_keyArray objectAtIndex:section]];
    return [data count];
} // section 中包含row的数量

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义一个静态标识符
    static NSString *cellIdentifier = @"cell";
    // 检查是否限制单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 创建单元格
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // 给cell内容赋值
    
    NSArray *data = [_dataDic objectForKey:[_keyArray objectAtIndex:indexPath.section]];
    NSString *fontName = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = fontName;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
    
} // 创建单元格

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keyArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keyArray;
} // 返回索引的内容

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"index : %d title : %@", index, title);
    return index;
} // 选中时，跳转表视图

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    NSArray *data = [_dataDic objectForKey:[_keyArray objectAtIndex:indexPath.section]];
    NSString *fontName = [data objectAtIndex:indexPath.row];
    for (NSDictionary *dic in aryOutlet) {
        if ([[dic objectForKey:@"firmdes"] isEqualToString:fontName]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAddNotification" object:dic];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];

            break;
        }
    }
    [SVProgressHUD dismiss];
//    [self dismissViewControllerAnimated:NO completion:^{
//        
//    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)navigationBarViewbackClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
