//
//  showTableViewController.m
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "showTableViewController.h"
#import "showTableCell.h"
#import "selectTableViewController.h"
#import "Chracter.h"
#import "StoreMessage.h"

@interface showTableViewController ()

@end

@implementation showTableViewController
{
    UITableView                 *_tableView;
    CGFloat                     VIEWSELFHEIGHT;
    NSMutableArray              *_dataArray;
    NSMutableArray              *_alphabetArray;//字母索引
    CVLocalizationSetting       *langSetting;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestStores];
}

//请求门店数据
-(void)requestStores
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getStore) toTarget:self withObject:nil];
}

//获取门店数据
-(void)getStore
{
    @autoreleasepool {
        DataProvider *dp=[DataProvider sharedInstance];
        dp.storeMessage=nil;
        NSMutableDictionary *dictValue=[[NSMutableDictionary alloc]init];
        [dictValue setValue:dp.selectCity.selectproviceId forKey:@"area"];
        [dictValue setValue:dp.selectTime forKey:@"dat"];
        [dictValue setObject:dp.selectBrank forKey:@"brandcode"];
        if([dp.selectCanCi isEqualToString:@"晚市"])
        {
            [dictValue setValue:@"2" forKey:@"sft"];
        }
        else
        {
            [dictValue setValue:@"1" forKey:@"sft"];
        }
        
        //        NSDictionary *dictStore=[[NSDictionary alloc]initWithDictionary:[dp getStoreByArea:dp.selectCity.selectproviceId]];
        NSDictionary *dictStore=[[NSDictionary alloc]initWithDictionary:[dp getStoreByArea:dictValue]];
        
        if ([[dictStore objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            NSArray *ary = [dictStore objectForKey:@"Message"];
            NSMutableArray  *dataArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in ary)
            {
                StoreMessage  *store=[[StoreMessage alloc]init];
                store.storeFirmdes =[dic objectForKey:@"firmdes"];
                store.storeFirmid =[dic objectForKey:@"firmid"];
                store.storeAddr =[dic objectForKey:@"addr"];
                store.storeArea =[dic objectForKey:@"area"];
                store.storeTele =[dic objectForKey:@"tele"];
                store.storeWbigPic =[dic objectForKey:@"wbigpic"];
                store.storeInit =[dic objectForKey:@"init"];
                store.storetableNum=[dic objectForKey:@"num"];
                store.storetableName=[dic objectForKey:@"resvDes"];
                store.storetablePax=[dic objectForKey:@"pax"];
                store.storetabletyp=[dic objectForKey:@"roomTyp"];
                store.storetableId=[dic objectForKey:@"resvId"];
                
                store.lunchstart=[dic objectForKey:@"lunchstart"];
                store.lunchendtime=[dic objectForKey:@"lunchendtime"];
                store.dinnerstart=[dic objectForKey:@"dinnerstart"];
                store.dinnerendtime=[dic objectForKey:@"dinnerendtime"];
                
                store.storeFirstAlp=@"";
                store.storeRoomArray=nil;
                store.storeTableArray=nil;
                [dataArray addObject:store];
            }
            if(dataArray.count==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无门店数据" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                });
                
            }
            else
            {
                [self AnalysisStoreDataWithDataArray:dataArray];
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dictStore objectForKey:@"Message"]];
        }
    }
    
}

//对获取的门店数据进行处理，按照首字母分类
-(void)AnalysisStoreDataWithDataArray:(NSMutableArray *)dataArray
{
    //    门店显示数据格式
    _dataArray=[[NSMutableArray alloc]init];
    _alphabetArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[dataArray count]; i++)
    {
        Chracter *chracter=[[Chracter alloc]init];
        NSString *result = [chracter getFirstChracter:((StoreMessage *)[dataArray objectAtIndex:i]).storeFirmdes];
        ((StoreMessage *)[dataArray objectAtIndex:i]).storeFirstAlp=result;
    }
    for (int i=0; i<[dataArray count]; i++)
    {
        StoreMessage *storei=(StoreMessage *)[dataArray objectAtIndex:i];
        storei.storeTableArray=[[NSMutableArray alloc]init];
        storei.storeRoomArray=[[NSMutableArray alloc]init];
        NSMutableDictionary *tableMessage=[[NSMutableDictionary alloc]init];
        [tableMessage setObject:storei.storetabletyp forKey:@"tableTyp"];
        [tableMessage setObject:storei.storetablePax forKey:@"tablePax"];
        [tableMessage setObject:storei.storetableNum forKey:@"tableNum"];
        [tableMessage setObject:storei.storetableName forKey:@"tableName"];
        [tableMessage setObject:storei.storetableId forKey:@"tableId"];
        if([storei.storetabletyp isEqualToString:[langSetting localizedString:@"rooms"]])
        {
            [storei.storeRoomArray addObject:tableMessage];
        }
        else
        {
            [storei.storeTableArray addObject:tableMessage];
        }
        
        //        将同一门店下的所有台位信息整理到一个对象下
        for (int j=i+1; j<[dataArray count]; j++)
        {
            StoreMessage *storej=(StoreMessage *)[dataArray objectAtIndex:j];
            if([storei.storeFirmid isEqualToString:storej.storeFirmid])
            {
                NSMutableDictionary *tableMessage=[[NSMutableDictionary alloc]init];
                [tableMessage setObject:storej.storetabletyp forKey:@"tableTyp"];
                [tableMessage setObject:storej.storetablePax forKey:@"tablePax"];
                [tableMessage setObject:storej.storetableNum forKey:@"tableNum"];
                [tableMessage setObject:storej.storetableName forKey:@"tableName"];
                [tableMessage setObject:storej.storetableId forKey:@"tableId"];
                if([storej.storetabletyp isEqualToString:[langSetting localizedString:@"rooms"]])
                {
                    [storei.storeRoomArray addObject:tableMessage];
                }
                else
                {
                    [storei.storeTableArray addObject:tableMessage];
                }
                [dataArray removeObjectAtIndex:j];
                j--;
            }
        }
    }
    
    //    如果存在改字母的则加入数据中，不存在则该字母不存在
    for (int i='A'; i<='Z'; i++)
    {
        NSMutableArray  *alphabetArray=[[NSMutableArray alloc]init];
        for (int j=0; j<[dataArray count]; j++)
        {
            if([[NSString stringWithFormat:@"%c",i]isEqualToString:((StoreMessage *)[dataArray objectAtIndex:j]).storeFirstAlp])
            {
                [alphabetArray addObject:[dataArray objectAtIndex:j]];
            }
        }
        if([alphabetArray count]>0)
        {
            NSLog(@"%@",alphabetArray);
            NSMutableDictionary  *dict=[[NSMutableDictionary alloc]init];
            [dict setObject: ((StoreMessage *)[alphabetArray objectAtIndex:0]).storeFirstAlp forKey:@"alphabet"];
            [dict  setObject:alphabetArray forKey:@"alphabetArray"];
            [_dataArray addObject:dict];
            [_alphabetArray addObject:((StoreMessage *)[alphabetArray objectAtIndex:0]).storeFirstAlp];
        }
    }
    bs_dispatch_sync_on_main_thread(^{
        [_tableView reloadData];
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
	// Do any additional setup after loading the view.
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWSELFHEIGHT=64.0;
    }
    else
    {
        VIEWSELFHEIGHT=44.0;
    }
    
    _alphabetArray=[[NSMutableArray alloc]initWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWSELFHEIGHT) andTitle:[langSetting localizedString:@"Stores to choose"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, VIEWSELFHEIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWSELFHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor orangeColor];
    [self.view addSubview:_tableView];
    
    
}

#pragma mark  ----uitableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    StoreMessage *store=[[[_dataArray objectAtIndex:indexPath.section] objectForKey:@"alphabetArray"]objectAtIndex:indexPath.row];
    //此处传的不是字典，是storeMessage对象
    
    //将选择的门店信息复制给单利
    
    DataProvider *dp =  [DataProvider sharedInstance];
    dp.storeMessage=store;
    
    //    将是被开始结束时间赋值给单利
    if([dp.selectCanCi isEqualToString:@"午市"])
    {
        dp.StartTime=store.lunchstart;
        dp.EndTime=store.lunchendtime;
    }
    else
    {
        dp.StartTime=store.dinnerstart;
        dp.EndTime=store.dinnerendtime;
    }
    
    
    NSLog(@"%@",dp.selectTime);
    if([self nowTime:[NSString stringWithFormat:@"%@ %@",dp.selectTime,dp.EndTime]])
    {
        selectTableViewController *selectTable=[[selectTableViewController alloc]initWithMessageDict:store];
        [self.navigationController pushViewController:selectTable animated:YES];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"你选择的门店\n最晚可预点时间早于当前时间\n请选择其他门店\n或重新选择餐次" delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        });
    }
    
}

//计算选择的时间是否超过当前时间 没超过返回YES
-(BOOL)nowTime:(NSString *)timeStr
{
    NSString *GLOBAL_TIMEFORMAT = @"yyyy-MM-dd HH:mm";
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:GLOBAL_TIMEFORMAT];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:timeStr];
    
    NSDate *firstDate = [NSDate dateWithTimeInterval:-3600*8 sinceDate:bdate];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeInterval _fitstDate = [firstDate timeIntervalSince1970]*1;
    NSTimeInterval _secondDate = [datenow timeIntervalSince1970]*1;
    
    if (_fitstDate - _secondDate > 0) {
        return YES;
    }
    return NO;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _alphabetArray;
    //    NSArray *indexList = [NSMutableArray arrayWithObjects:
    //                          @"A", @"B", @"C", @"D", @"E", @"F",
    //                          @"G", @"H", @"I", @"J", @"K", @"L",
    //                          @"M", @"N", @"O", @"P", @"Q", @"R",
    //                          @"S", @"T", @"U", @"V", @"W", @"X",
    //                          @"Y", @"Z", @"#", nil
    //                          ];
    //    NSLog(@"%@",indexList);
    //    return indexList ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([((StoreMessage *)[[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"alphabetArray"]objectAtIndex:indexPath.row]).storeRoomArray count]>0)
    {
        return ([((StoreMessage *)[[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"alphabetArray"]objectAtIndex:indexPath.row]).storeTableArray count]+3)*25;
    }
    else
    {
        return ([((StoreMessage *)[[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"alphabetArray"]objectAtIndex:indexPath.row]).storeTableArray count]+2)*25;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_dataArray objectAtIndex:section]objectForKey:@"alphabetArray"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    showTableCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[showTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [cell setMessageByDict:[[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"alphabetArray"]objectAtIndex:indexPath.row]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section]objectForKey:@"alphabet"];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, 25)];
    view.backgroundColor=[UIColor clearColor];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10,0 , SUPERVIEWWIDTH-10 , 25)];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.textAlignment=NSTextAlignmentLeft;
    lbl.font=[UIFont systemFontOfSize:15];
    lbl.text=[[_dataArray objectAtIndex:section]objectForKey:@"alphabet"];
    lbl.textColor=[UIColor grayColor];
    [view addSubview:lbl];
    return view;
}
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
