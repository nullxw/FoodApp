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
    
    UIButton            *_rightButton;
    
    BOOL                _isShow;//是否显示下拉的选项
    
    UIButton              *_orderStoryView;
    
    /*
    NSMutableArray      *_dataYear;
    NSMutableArray      *_dataMoon;
    NSMutableArray      *_dataDay;
    
    
    NSInteger           selectYear;
    NSInteger           selectMoon;
    NSInteger           selectDay;
    
    NSString            *NowMoon;  //当前月份
    NSString            *NowDay;    //当前日
    UIView              *vPicker;
    UIPickerView        *_pickViewTime;
    
    UILabel             *_selectDate;
     */
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
    
    _isShow=NO;
    _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:[langSetting localizedString:@"My reservation"] forState:UIControlStateNormal];
    
    _rightButton.frame=CGRectMake(nvc.frame.size.width-110, nvc.frame.size.height-44, 100, 34);
    [_rightButton addTarget:self action:@selector(orderStory) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundColor:selfbackgroundColor];
    [nvc addSubview:_rightButton];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Order_orderStory.png"]];
    image.frame=CGRectMake(_rightButton.frame.size.width-5, _rightButton.frame.size.height-6, 5, 6);
    [_rightButton addSubview:image];
    
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
//                    NSString *orderTime=[NSString stringWithFormat:@"%@ 00:00",[dict objectForKey:@"dat"]];
                    NSString *orderTime=[NSString stringWithFormat:@"%@",[dict objectForKey:@"dat"]];
                    
                    if([DataProvider compareTimeOne:orderTime andTimeTwo:[self nowTime]])
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
    
    //    判断账单是否过期
    NSString *orderTime=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"dat"],[dict objectForKey:@"datmins"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[[NSDate alloc]init];
    date=[[dateFormatter dateFromString:orderTime] dateByAddingTimeInterval:15*60];
    orderTime=[dateFormatter stringFromDate:date];
    
    NSString *outTime=@"";
    if(![DataProvider compareNowTime:orderTime])
    {
        outTime=@"已过期";
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"就餐时间:%@ %@ %@\n订单编号:%@",[dict objectForKey:@"dat"],[dict objectForKey:@"datmins"],outTime,[dict objectForKey:@"resv"]]];
    NSString *indexStr=[NSString stringWithFormat:@"%@",str];
    NSRange range=[indexStr rangeOfString:@"已过期"];
    [str addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:range];
    cell.detailTextLabel.numberOfLines=2;
    cell.detailTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.detailTextLabel.attributedText=str;
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


//下拉选择历史账单
-(void)orderStory
{
    if(!_orderStoryView)
    {
        _orderStoryView=[UIButton buttonWithType:UIButtonTypeCustom];
        
        if([_rightButton.titleLabel.text isEqualToString:[langSetting localizedString:@"My reservation"]])
        {
            [_orderStoryView setTitle:@"历史账单" forState:UIControlStateNormal];
        }
        else
        {
           [_orderStoryView setTitle:[langSetting localizedString:@"My reservation"] forState:UIControlStateNormal];
        }
        _orderStoryView.frame=CGRectMake(_rightButton.center.x-(_rightButton.frame.size.width/2), _rightButton.frame.origin.y+_rightButton.frame.size.height+10, 100, 35);
        
        [_orderStoryView addTarget:self action:@selector(selectOrderStory) forControlEvents:UIControlEventTouchUpInside];
        [_orderStoryView setBackgroundImage:[UIImage imageNamed:@"Order_orderPullNomel.png"] forState:UIControlStateNormal];
        [_orderStoryView setBackgroundImage:[UIImage imageNamed:@"Order_orderPullSelect.png"] forState:UIControlStateSelected];
        _orderStoryView.transform=CGAffineTransformMakeScale(0.1, 0.1);
        [self.view addSubview:_orderStoryView];
        [UIView animateWithDuration:0.2f animations:^{
            _orderStoryView.transform=CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        _orderStoryView.transform=CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.2f animations:^{
            _orderStoryView.transform=CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [_orderStoryView removeFromSuperview];
            _orderStoryView=nil;
        }];

       
    }
}


-(void)selectOrderStory
{
    if(_orderStoryView)
    {
        _orderStoryView.transform=CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.2f animations:^{
            _orderStoryView.transform=CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [_orderStoryView removeFromSuperview];
            _orderStoryView=nil;
            if([_rightButton.titleLabel.text isEqualToString:@"历史账单"])
            {
                [_rightButton setTitle:[langSetting localizedString:@"My reservation"] forState:UIControlStateNormal];
                _dataArray=[[NSMutableArray alloc]init];
                for (NSDictionary *dict in _allDataArray)
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
            }
            else
            {
                [_rightButton setTitle:@"历史账单" forState:UIControlStateNormal];
                _dataArray=[[NSMutableArray alloc]initWithArray:_allDataArray];
                
            }
            [_tableView reloadData];
            
        }];
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

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    view.backgroundColor=[UIColor clearColor];
    //        开始日期
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 5, ScreenWidth-80, 30);
    button.backgroundColor=kgrayColor;
    [button addTarget:self action:@selector(buttonClickDate) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *lblDateLeft=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
    lblDateLeft.text=[NSString stringWithFormat:@"%@:",@"历史查询"];//[langSetting localizedString:@"Query the date"]
    lblDateLeft.backgroundColor=[UIColor clearColor];
    lblDateLeft.textAlignment=NSTextAlignmentLeft;
    lblDateLeft.font=[UIFont systemFontOfSize:14];
    [button addSubview:lblDateLeft];
    
    
    _selectDate=[[UILabel alloc]initWithFrame:CGRectMake(lblDateLeft.frame.origin.y+lblDateLeft.frame.size.width, 0, button.frame.size.width-lblDateLeft.frame.size.width, 30)];
    _selectDate.text=[NSString stringWithFormat:@"%@",[self nowTime]];//[langSetting localizedString:@"Query the date"]
    _selectDate.backgroundColor=[UIColor clearColor];
    _selectDate.textAlignment=NSTextAlignmentCenter;
    _selectDate.font=[UIFont systemFontOfSize:14];
    [button addSubview:_selectDate];

    UIButton *btnquery=[UIButton buttonWithType:UIButtonTypeCustom];
    btnquery.frame=CGRectMake(button.frame.size.width+button.frame.origin.x, 5,ScreenWidth-button.frame.size.width, 30);
    [btnquery setTitle:[langSetting localizedString:@"query"] forState:UIControlStateNormal];
    btnquery.backgroundColor=selfbackgroundColor;
    [btnquery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnquery addTarget:self action:@selector(btnquery) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnquery];
    
    UIButton *btnquery=[UIButton buttonWithType:UIButtonTypeCustom];
    btnquery.frame=CGRectMake(0, 5,ScreenWidth, 30);
    [btnquery setTitle:@"当前账单" forState:UIControlStateNormal];
    btnquery.backgroundColor=selfbackgroundColor;
    [btnquery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnquery addTarget:self action:@selector(btnquery) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnquery];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(lblDateLeft.frame.origin.y+lblDateLeft.frame.size.width, 0, button.frame.size.width-lblDateLeft.frame.size.width, 30)];
    title.text=[NSString stringWithFormat:@"%@",[self nowTime]];//[langSetting localizedString:@"Query the date"]
    title.backgroundColor=[UIColor clearColor];
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:14];
    [btnquery addSubview:title];

    
    return view;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
*/


/*
 
 -(void)buttonClickDate
 {
 
 }
 
//显示PickView
-(void)showPickView{
    if(!vPicker)
    {
        vPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        UIImage *root_image;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            toolbar.frame = CGRectMake(0, vPicker.frame.size.height-218-42, ScreenWidth, 44);
            root_image = [UIImage imageNamed:@"Order_bgPick.png"];
        }else{
            toolbar.frame = CGRectMake(0, vPicker.frame.size.height-218-44-18, ScreenWidth, 44);
            root_image = [UIImage imageNamed:@"Order_bgPick2.png"];
        }
        
        
        if ([toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [toolbar setBackgroundImage:root_image forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
        }else{
            toolbar.barStyle = UIToolbarPositionTop;
        }
        
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        [vPicker addSubview:toolbar];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn sizeToFit];
        btn.frame = CGRectMake(0, 0, 60, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:[langSetting localizedString:@"cancel"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        btn.center = CGPointMake(10+btn.frame.size.width/2, 22);
        [toolbar addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn sizeToFit];
        btn.frame = CGRectMake(0, 0, 60, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        btn.center = CGPointMake(ScreenWidth-10-btn.frame.size.width/2, 22);
        [toolbar addSubview:btn];
        
        _pickViewTime= [[UIPickerView alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            _pickViewTime.frame = CGRectMake(0, vPicker.frame.size.height-216, ScreenWidth, 218) ;
        }else{
            _pickViewTime.frame = CGRectMake(0, vPicker.frame.size.height-216, ScreenWidth, 218) ;
        }
        _pickViewTime.showsSelectionIndicator = YES;
        _pickViewTime.delegate = self;
        _pickViewTime.dataSource = self;
        _pickViewTime.backgroundColor = [UIColor whiteColor];
        
        [vPicker addSubview:_pickViewTime];
        
        vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
        [self.view addSubview:vPicker];
        
        [UIView animateWithDuration:.3f animations:^{
            vPicker.frame = CGRectMake(0, 0, vPicker.frame.size.width, vPicker.frame.size.height);
        }];
    }
    else
    {
        NSLog(@"存在");
    }
}

- (void)cancelClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
    }];
}

- (void)confirmClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
    }];
    NSString *stingDay=[NSString stringWithFormat:@"%ld",(long)selectDay];
    if(selectDay<10)
    {
        stingDay=[NSString stringWithFormat:@"0%ld",(long)selectDay];
    }
    NSString *stingMoon=[NSString stringWithFormat:@"%ld",(long)selectMoon];
    if(selectMoon<10)
    {
        stingMoon=[NSString stringWithFormat:@"0%ld",(long)selectMoon];
    }
    
    _selectDate.text=[NSString stringWithFormat:@"%ld-%@-%@",(long)selectYear,stingMoon,stingDay];
    
}


#pragma mark pickViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0)
    {
        selectYear =[[_dataYear objectAtIndex:row]integerValue];
        [_pickViewTime reloadAllComponents];
    }
    else if(component==1)
    {
        selectMoon=[[_dataMoon objectAtIndex:row]integerValue];
        [_pickViewTime reloadAllComponents];
    }
    else
    {
        selectDay=[[_dataDay objectAtIndex:row]integerValue];
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component==0)
    {
        return [_dataYear count];
    }
    else if (component==1)
    {
        return [_dataMoon count];
    }
    else
    {
        //判断平年闰年
        BOOL rainYear=NO;
        if(selectYear%4==0 ||(selectYear%100==0 &&selectYear%400==0))
        {
            rainYear=YES;
        }
        else
        {
            rainYear=NO;
        }
        
        int MoonDay;
        selectMoon=[[_dataMoon objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
        
        if(selectMoon==1||selectMoon==3||selectMoon==5||selectMoon==7||selectMoon==8||selectMoon==10||selectMoon==12)
        {
            MoonDay=31;
        }
        else if(selectMoon==4||selectMoon==6||selectMoon==9||selectMoon==11)
        {
            MoonDay=30;
        }
        else
        {
            if(rainYear)
            {
                MoonDay=29;
            }
            else
            {
                MoonDay=28;
            }
        }
        _dataDay=[[NSMutableArray alloc]init];
        
        if([NowMoon integerValue]==selectMoon)
        {
            MoonDay=[NowDay integerValue];//当前月份，日期从当前日期开始，否则，从1号开始
        }
        for(int i=1;i<=MoonDay;i++)
        {
            [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
        }
        return [_dataDay count];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 3;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(component==0)
    {
        selectYear=[[_dataYear objectAtIndex:row]integerValue];
        return [_dataYear objectAtIndex:row];
    }
    else if (component==1)
    {
        selectMoon=[[_dataMoon objectAtIndex:row]integerValue];
        return [_dataMoon objectAtIndex:row];
    }
    else
    {
        
        selectDay=[[_dataDay objectAtIndex:row]integerValue];
        return [_dataDay objectAtIndex:row];
    }
}


-(void)initArray
{
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
    NowMoon=MM;
    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dd = [dateFormatter stringFromDate:localeDate];
    NowDay=dd;
    _dataMoon=[[NSMutableArray alloc]init];
    _dataDay=[[NSMutableArray alloc]init];
    _dataYear=[[NSMutableArray alloc]initWithObjects:yy, nil];
    for(int i=1;i<=[MM integerValue];i++)
    {
        [_dataMoon addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=1;i<=[dd integerValue];i++)
    {
        [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}
*/

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
