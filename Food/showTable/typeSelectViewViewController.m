//
//  typeSelectViewViewController.m
//  Food
//
//  Created by sundaoran on 14-4-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "typeSelectViewViewController.h"
#import "FMDatabase.h"
#import "DataProvider.h"


@interface typeSelectViewViewController ()

@end


@implementation typeSelectViewViewController
{
    viewSelectType viewTypeStyle;
    CGFloat        VIEWSELFHEIGHT;
    UITableView     *_tableView;
    NSMutableArray      *_dataArray;
    NSString            *_name;
    CVLocalizationSetting *langSetting;
}

@synthesize delegate=_delegate;
@synthesize selectBrank;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithViewType:(viewSelectType )viewType andName:(NSString *)name
{
    if (self==[super init])
    {
        viewTypeStyle=viewType;
        if(name!=nil)
        {
            _name=name;
        }
    }
    return self;
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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-44) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _dataArray=[[NSMutableArray alloc]init];
    
    NSString *title=@"";
    if(viewTypeStyle==viewSelectProvice)
    {
        title=[langSetting localizedString:@"Select Province"];
        //        @"选择省份";
        [self.view addSubview:_tableView];
        [NSThread detachNewThreadSelector:@selector(getMessageByselectSentenceFormDb:) toTarget:self withObject:@"SELECT *FROM T_Province"];
    }
    else if(viewTypeStyle==viewSelectOnlyCity)
    {
        title=[langSetting localizedString:@"Select City"];
        //        @"选择城市";
        [self.view addSubview:_tableView];
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(getOnlyCity) toTarget:self withObject:nil];
    }
    else if (viewTypeStyle==viewSelectCiry)
    {
        title=[langSetting localizedString:@"Select City"];
        //        @"选择城市";
        [self.view addSubview:_tableView];
        [NSThread detachNewThreadSelector:@selector(getMessageByselectSentenceFormDb:) toTarget:self withObject:[NSString stringWithFormat:@"SELECT *FROM T_City WHERE ProID='%@'",_name]];
    }
    else if (viewTypeStyle==viewSelectArea)
    {
        title=[langSetting localizedString:@"Select Area"];
        //        @"选择区域";
        [self.view addSubview:_tableView];
        [NSThread detachNewThreadSelector:@selector(getMessageByselectSentenceFormDb:) toTarget:self withObject:[NSString stringWithFormat:@"SELECT *FROM T_Zone WHERE CityID='%@'",_name]];
    }
    else if (viewTypeStyle==viewSelectDate)
    {
        title=[langSetting localizedString:@"Select Date"];
        //        @"选择日期";
    }
    else if (viewTypeStyle==viewSelectMenDian)
    {
        title=[langSetting localizedString:@"Select Stores"];
        //        @"选择门店";
    }
    else if (viewTypeStyle==viewSelectShiBie)
    {
        title=[langSetting localizedString:@"Select Market"];
        //        @"选择市别";
        [self.view addSubview:_tableView];
        _dataArray=[[NSMutableArray alloc]initWithObjects:@"午市",@"晚市", nil];
    }
    else if (viewTypeStyle==viewSelectTime)
    {
        title=[langSetting localizedString:@"Select Time"];
        //        @"选择时间";
        [self.view addSubview:_tableView];
        DataProvider *dp=[DataProvider sharedInstance];
        _dataArray = [self getTimeArray:dp.StartTime andEndTime:dp.EndTime andInterval:@"15"];
        
    }
    else if (viewTypeStyle==viewSelectBrank)
    {
        title= @"选择品牌";
        //        @"选择品牌";
        [self.view addSubview:_tableView];
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(getBrands) toTarget:self withObject:nil];
    }
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWSELFHEIGHT) andTitle:title];
    nvc.delegate=self;
    [self.view addSubview:nvc];
}

-(void)getBrands
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp getBrands];
        if ([[dict objectForKey:@"Result"] boolValue]) {
            
            NSArray *valueArray = [dict objectForKey:@"Message"];
            _dataArray=[[NSMutableArray alloc]init];
            for (NSMutableDictionary *dictValue in valueArray)
            {
                NSLog(@"%@",dictValue);
                [_dataArray addObject:dictValue];
            }
            
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
    
}

//获取时间间隔，根据开始时间，结束时间和间隔时间获取所有的时间段
-(NSMutableArray *)getTimeArray:(NSString *)startTime andEndTime:(NSString *)endTime andInterval:(NSString *)interval
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSDate *localeDate = [datenow  dateByAddingTimeInterval:([interval integerValue]*60)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'"];
    //用[NSDate date]可以获取系统当前时间
    NSString *nowDate = [dateFormatter stringFromDate:localeDate];
    
    NSString *startDate=[nowDate stringByAppendingString:[NSString stringWithFormat:@" %@",startTime]];
    NSString *endDate=[nowDate stringByAppendingString:[NSString stringWithFormat:@" %@",endTime]];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *satrt= [dateFormatter dateFromString:startDate];
    NSDate *end= [dateFormatter dateFromString:endDate];
    NSTimeInterval allInterval=[end timeIntervalSinceDate:satrt];
    
    int count=allInterval/([interval integerValue]*60);
    [array addObject:[[startDate componentsSeparatedByString:@" "]lastObject]];
    for (int i=0; i< count;i++)
    {
        NSDate *countDate=[satrt  dateByAddingTimeInterval: ([interval integerValue]*60)];
        NSString *date=[dateFormatter stringFromDate:countDate];
        [array addObject:[[date componentsSeparatedByString:@" "]lastObject]];
        satrt=countDate;
    }
    
    return array;
}


-(NSMutableArray *)getTimeList:(NSString *)startTime andEndTime:(NSString *)endTime andTimeInterval:(NSString *)interval
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    return array;
    
}



//选择城市通过接口
-(void)getOnlyCity
{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dicCity = [dp getCity];
        if ([[dicCity objectForKey:@"Result"] boolValue]) {
            NSArray *ary = [dicCity objectForKey:@"Message"];
            for (NSDictionary *dic in ary)
            {
                changeCity *change=[[changeCity alloc]init];
                change.selectprovice=[dic objectForKey:@"des"];
                change.selectproviceId=[dic objectForKey:@"sno"];
                [_dataArray addObject:change];
                
            }
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:[dicCity objectForKey:@"Message"]];
        }
    }
    
}


//选择城市，地区通过本地数据库
-(void)getMessageByselectSentenceFormDb:(NSString *)selectSentence
{
    @autoreleasepool {
        NSString *path=[NSString stringWithFormat:@"%@",[[NSBundle mainBundle]pathForResource:@"city_zone" ofType:@"db"]];
        FMDatabase *fmdb=[[FMDatabase alloc]initWithPath:path];
        
        _dataArray=[[NSMutableArray alloc]init];
        if(![fmdb open])
        {
            return;
        }
        else
        {
            FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
            while([resultSet next])
            {
                if(viewTypeStyle==viewSelectProvice)
                {
                    changeCity *change=[[changeCity alloc]init];
                    change.selectprovice=[resultSet stringForColumn:@"ProName"];
                    change.selectproviceId=[resultSet stringForColumn:@"ProSort"];
                    [_dataArray addObject:change];
                }
                else if(viewTypeStyle==viewSelectOnlyCity)
                {
                    changeCity *change=[[changeCity alloc]init];
                    change.selectprovice=[resultSet stringForColumn:@"ProName"];
                    change.selectproviceId=[resultSet stringForColumn:@"ProSort"];
                    [_dataArray addObject:change];
                }
                else if (viewTypeStyle==viewSelectCiry)
                {
                    changeCity *change=[[changeCity alloc]init];
                    change.selectCity=[resultSet stringForColumn:@"CityName"];
                    change.selectCityId=[resultSet stringForColumn:@"CitySort"];
                    [_dataArray addObject:change];
                }
                else if (viewTypeStyle==viewSelectArea)
                {
                    changeCity *change=[[changeCity alloc]init];
                    change.selectArea=[resultSet stringForColumn:@"ZoneName"];
                    change.selectAreaId=[resultSet stringForColumn:@"ZoneID"];
                    [_dataArray addObject:change];
                }
            }
            [fmdb close];
        }
        
        [_tableView reloadData];
    }
    
}

#pragma mark UItableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(viewTypeStyle==viewSelectProvice)
    {
        [_delegate setpro:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if(viewTypeStyle==viewSelectOnlyCity)
    {
        [_delegate setpro:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if (viewTypeStyle==viewSelectCiry)
    {
        [_delegate setCity:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if (viewTypeStyle==viewSelectArea)
    {
        [_delegate setArea:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if (viewTypeStyle==viewSelectDate)
    {
        
    }
    else if (viewTypeStyle==viewSelectShiBie)
    {
        [_delegate setShiBie:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if (viewTypeStyle==viewSelectTime)
    {
        [_delegate setTime:[_dataArray objectAtIndex:indexPath.row]];
    }
    else if (viewTypeStyle==viewSelectBrank)
    {
        selectBrank([_dataArray objectAtIndex:indexPath.row]);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    if(viewTypeStyle==viewSelectProvice)
    {
        cell.textLabel.text=((changeCity *)[_dataArray objectAtIndex:indexPath.row]).selectprovice;
    }
    else if(viewTypeStyle==viewSelectOnlyCity)
    {
        cell.textLabel.text=((changeCity *)[_dataArray objectAtIndex:indexPath.row]).selectprovice;
    }
    else if (viewTypeStyle==viewSelectCiry)
    {
        cell.textLabel.text=((changeCity *)[_dataArray objectAtIndex:indexPath.row]).selectCity;
    }
    else if (viewTypeStyle==viewSelectArea)
    {
        cell.textLabel.text=((changeCity *)[_dataArray objectAtIndex:indexPath.row]).selectArea;
    }
    else if (viewTypeStyle==viewSelectTime ||viewTypeStyle==viewSelectShiBie)
    {
        cell.textLabel.text=[_dataArray objectAtIndex:indexPath.row];
    }
    else if(viewTypeStyle==viewSelectBrank)
    {
        cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"name"];
    }
    
    return cell;
}

-(void)navigationBarViewbackClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
