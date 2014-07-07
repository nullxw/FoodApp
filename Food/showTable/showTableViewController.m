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
#import "WebImageView.h"

@interface showTableViewController ()

@end

@implementation showTableViewController
{
    UITableView                 *_tableViewOtherType;
    
    CGFloat                     VIEWSELFHEIGHT;
    NSMutableArray              *_dataArray;
    NSMutableArray              *_alphabetArray;//字母索引
    CVLocalizationSetting       *langSetting;
    
    UIView                      *_tableMessageView;
    
    NSMutableArray              *_dataButton;
    NSMutableArray              *_dataImageView;
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
        if([dp.selectCanCi isEqualToString:@"晚餐"])
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
//        台位排序
       storei.storeTableArray=[[NSMutableArray alloc]initWithArray:[storei.storeTableArray sortedArrayUsingComparator:cmptr]];
    }
    
    //    如果存在改字母的则加入数据中，不存在则该字母不存在
    for (int i='A'; i<='Z'; i++)
    {
        NSMutableArray  *alphabetArray=[[NSMutableArray alloc]init];
        for (int j=0; j<[dataArray count]; j++)
        {
            if([[NSString stringWithFormat:@"%c",i]isEqualToString:((StoreMessage *)[dataArray objectAtIndex:j]).storeFirstAlp])
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:[dataArray objectAtIndex:j] forKey:@"store"];
                [dict  setObject:[NSNumber numberWithBool:NO] forKey:@"isOpen"];
                
                WebImageView *imageView=[[WebImageView alloc]initWithImage:[UIImage imageNamed:@"Public_default.png"]];
                imageView.frame=CGRectMake(10, 5, 90, 70);
                [dict setObject:imageView forKey:((StoreMessage*)[dataArray objectAtIndex:j]).storeFirmid];
                [self getImage:dict];
//                [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:dict];
                [_dataImageView addObject:imageView];
                
                [alphabetArray addObject:dict];
            }
        }
        if([alphabetArray count]>0)
        {
            NSMutableDictionary  *dict=[[NSMutableDictionary alloc]init];
            [dict setObject: ((StoreMessage *)[[alphabetArray objectAtIndex:0]objectForKey:@"store"]).storeFirstAlp forKey:@"alphabet"];
            [dict  setObject:alphabetArray forKey:@"alphabetArray"];
            for (NSMutableDictionary *value in alphabetArray)
            {
                [_dataArray addObject:value];
            }
            [_alphabetArray addObject:((StoreMessage *)[[alphabetArray objectAtIndex:0]objectForKey:@"store"]).storeFirstAlp];
        }
    }

        [_tableViewOtherType reloadData];
}

//对台为按照台位人数多少进行排序
NSComparator cmptr = ^(id obj1, id obj2){
    
//    降序
    if ([[obj1 objectForKey:@"tablePax"] integerValue] > [[obj2 objectForKey:@"tablePax"] integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
//    升序
    if ([[obj1 objectForKey:@"tablePax"] integerValue] < [[obj2 objectForKey:@"tablePax"] integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
//    相同
    return (NSComparisonResult)NSOrderedSame;
};

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
    
    _dataButton=[[NSMutableArray alloc]init];
    _dataImageView=[[NSMutableArray alloc]init];
    _alphabetArray=[[NSMutableArray alloc]initWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWSELFHEIGHT) andTitle:[langSetting localizedString:@"Stores to choose"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _tableViewOtherType=[[UITableView alloc]initWithFrame:CGRectMake(0, VIEWSELFHEIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWSELFHEIGHT-10) style:UITableViewStylePlain];
    _tableViewOtherType.delegate=self;
    _tableViewOtherType.dataSource=self;
    _tableViewOtherType.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewOtherType];
    
    
}

#pragma mark  ----uitableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[[_dataArray objectAtIndex:section]objectForKey:@"isOpen"]boolValue])
    {
        return 1;
    }
    else
    {
        return 0;
    }
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setMessageByDict:[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"store"]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreMessage *store=[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"store"];
    if([[[_dataArray objectAtIndex:indexPath.section]objectForKey:@"isOpen"]boolValue])
    {
        if([store.storeRoomArray count]>0)
        {
            return ([store.storeTableArray count]+2)*25+40;
        }
        else
        {
            return ([store.storeTableArray count]+1)*25+40;
        }
    }
    else
    {
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    backView.backgroundColor=[UIColor whiteColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    button.frame=CGRectMake(5, 2, ScreenWidth-21, 78);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(buttonSectionClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=section;
    
    WebImageView *imageView=(WebImageView *)[[_dataArray objectAtIndex:section]objectForKey:((StoreMessage *)[[_dataArray objectAtIndex:section]objectForKey:@"store"]).storeFirmid];
    [button addSubview:imageView];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,0 , SUPERVIEWWIDTH-170 , 80)];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.textAlignment=NSTextAlignmentLeft;
    lbl.font=[UIFont systemFontOfSize:15];
    lbl.text=((StoreMessage *)[[_dataArray objectAtIndex:section]objectForKey:@"store"]).storeFirmdes;
    lbl.textColor=selfbackgroundColor;
    
    [button addSubview:lbl];
    button.layer.borderWidth=0.5;
    button.layer.borderColor=selfborderColor.CGColor;
    button.layer.cornerRadius=5;
    [_dataButton addObject:button];
    
    [backView addSubview:button];
    
    return backView;
}


//获取图片路径
-(void)getImage:(NSMutableDictionary *)dict
{
//    @autoreleasepool {
        WebImageView *imageView=[dict objectForKey:((StoreMessage *)[dict objectForKey:@"store"]).storeFirmid];
       NSString *url=[NSString stringWithFormat:@"%@%@",[[DataProvider getIpPlist]objectForKey:@"storesPicURL"],((StoreMessage *)[dict objectForKey:@"store"]).storeWbigPic];
        if([DataProvider imageCache:url])
        {
            [imageView setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
            NSLog(@"--->>本地");
        }
        else
        {
            [imageView setImageURL:[NSURL URLWithString:url] andImageBoundName:@"Public_default.png"];
             NSLog(@"===>>请求");
        }
//    }
}
-(void)buttonSectionClick:(UIButton *)button
{
    if([[[_dataArray objectAtIndex:button.tag] objectForKey:@"isOpen"]boolValue])
    {
        [[_dataArray objectAtIndex:button.tag] setObject:[NSNumber numberWithBool:NO] forKey:@"isOpen"];
    }
    else
    {
        for (UIButton *btn in _dataButton)
        {
            NSMutableDictionary *dict=[_dataArray objectAtIndex:btn.tag];
            if(btn==button)
            {
                [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isOpen"];
            }
            else
            {
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isOpen"];
            }
            
        }
        
    }
    [_tableViewOtherType reloadData];
}

//取消图片请求
-(void)cancelRequest{
    for (WebImageView *webImg in _dataImageView) {
        [webImg cancelRequest];
    }
}

-(void)navigationBarViewbackClick
{
//    bs_dispatch_sync_on_main_thread(^{
        [self cancelRequest];
       [self.navigationController popViewControllerAnimated:YES];
//    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
