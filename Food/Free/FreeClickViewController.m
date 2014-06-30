//
//  FreeClickViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "FreeClickViewController.h"
#import "DataProvider.h"
#import "OutletViewController.h"
#import "BSBookViewController.h"
#import "shareInfoData.h"
#import "privilegeViewController.h"

@interface FreeClickViewController ()
{
    typeSelectViewViewController *typeView;
    BOOL        isCity;         //用于判断是否选择了城市
    BOOL        isMendian;      //用于判断是否选择了门店
    BOOL        isDate;         //用于判断是否选择了日期
    BOOL        isShiBie;       //用于判断是否选择了市别
    BOOL        isTime;         //用于判断是否选择了时间
}

@end

@implementation FreeClickViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    langSetting = [CVLocalizationSetting sharedInstance];
    flag = 1;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHRIGHT=64.0;
    }
    else
    {
        VIEWHRIGHT=44.0;
    }
    
    [self initArray];  //初始化
    
    selectYear=[[_dataYear objectAtIndex:0]integerValue];
    selectMoon=[[_dataMoon objectAtIndex:0]integerValue];
    selectDay=[[_dataDay objectAtIndex:0]integerValue];

    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Self help order"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    for (int i=0; i<5; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(10, i%5*62+20, ScreenWidth-20, 60);
        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setTag:100+i];
        button.layer.borderColor=selfborderColor.CGColor;
        button.layer.borderWidth=0.5f;
        button.layer.cornerRadius=3;
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backGround addSubview:button];
        
        UIImageView *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
        [button addSubview:imageViewLeft];
        
        UILabel  *lblLeft=[[UILabel  alloc]initWithFrame:CGRectMake(30, 20, 70, 20)];
        lblLeft.font=[UIFont systemFontOfSize:17];
        lblLeft.backgroundColor=[UIColor clearColor];
        [button addSubview:lblLeft];
        
        UILabel  *lblright=[[UILabel  alloc]initWithFrame:CGRectMake(button.frame.size.width-90, 20, 70, 20)];
        lblright.font=[UIFont systemFontOfSize:17];
        lblright.backgroundColor=[UIColor clearColor];
        lblright.tag = 200+i;
        lblright.textAlignment = NSTextAlignmentCenter;
        [button addSubview:lblright];

        UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-20, 20, 20, 20)];
        [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
        [button addSubview:imgJianTou];
        
        switch (i)
        {
            case 0:
            {
                lblLeft.text=[langSetting localizedString:@"city"];
                lblright.text=[langSetting localizedString:@"Select City"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
            }
                break;
            case 1:
            {
                lblLeft.text=[langSetting localizedString:@"stores"];
                lblright.text=[langSetting localizedString:@"Select Stores"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_shop.png"]];
            }
                break;
            case 2:
            {
                lblLeft.text=[langSetting localizedString:@"A due date"];
                lblright.text=[langSetting localizedString:@"Select Date"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_date.png"]];
            }
                break;
            case 3:
            {
                lblLeft.text=[langSetting localizedString:@"market"];
                lblright.text=[langSetting localizedString:@"Select Market"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_meal.png"]];
            }
                break;
            case 4:
            {
                lblLeft.text=[langSetting localizedString:@"time"];
                lblright.text=[langSetting localizedString:@"Select Time"];
                [imageViewLeft setImage:[UIImage imageNamed:@"Public_time.png"]];
            }
                break;
                
            default:
                break;
        }
    }
    
    UIButton  *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if(VIEWHRIGHT==44.0)
    {
    nextButton.frame=CGRectMake(10, 350, ScreenWidth-20, 30);
    }
    else
    {
       nextButton.frame=CGRectMake(10, 350, ScreenWidth-20, 30);
    }
    [nextButton setTitle:[langSetting localizedString:@"Next step"] forState:UIControlStateNormal];
    [nextButton setTag:1001];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:nextButton];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMenDian:) name:@"ChangeAddNotification" object:nil];
}

-(void)AddMenDian:(NSNotification *)notification{
    dicStore =(NSDictionary *)[notification object];
    NSString *str = [dicStore objectForKey:@"firmdes"];
    UILabel *lblMenDian = (UILabel *)[self.view viewWithTag:201];
    lblMenDian.text = str;
    lblMenDian.textAlignment = NSTextAlignmentRight;
    lblMenDian.frame = CGRectMake(100, 20, 190, 20);
    isMendian=YES;
   
}

-(void)ButtonClick:(UIButton *)button
{
    if (button.tag == 100) {  //城市
//        flag = 1;
//        [self showPickView];
        typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }else if (button.tag == 101){//门店
        if (strCityCode == nil) {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"请选择城市" delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];//[langSetting localizedString:@"City code is empty"]
                [alert show];
            });
            
        }else{
            OutletViewController *outlet = [[OutletViewController alloc] init];
            outlet.cityCode = strCityCode;
            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:outlet];
            nvc.navigationBar.hidden=YES;
            nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//            [self.navigationController pushViewController:outlet animated:YES];
            [self presentViewController:nvc animated:YES completion:^{
                
            }];
            
        }
        
    }else if (button.tag == 102){//预定日期
        flag = 2;
        [self showPickView];
    }else if (button.tag == 103){//市别
//        flag = 3;
//        [self showPickView];
        typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectShiBie andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }else if (button.tag == 104){//时间
//        flag = 4;
//        [self showPickView];
        if(!isShiBie)
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"请选择市别" delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
            });
            
        }
        else if(!isMendian)
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"请选择门店" delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
            });
            
        }
        else
        {
            typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectTime andName:[DataProvider sharedInstance].selectCanCi];
            typeView.delegate=self;
            UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
            nvc.navigationBar.hidden=YES;
            nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nvc animated:YES completion:^{
                
            }];


        }
    }
}

-(void)nextButtonClick
{
    //城市
    UILabel *lblCity = (UILabel *)[self.view viewWithTag:200];
    if ([lblCity.text isEqualToString:[langSetting localizedString:@"Select City"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select City"]];
        return;
    }
    //门店
    UILabel *lblMenDian = (UILabel *)[self.view viewWithTag:201];
    if ([lblMenDian.text isEqualToString:[langSetting localizedString:@"Select Stores"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select Stores"]];
        return;
    }
    //预定日期
    UILabel *lblYuDing = (UILabel *)[self.view viewWithTag:202];
    if ([lblYuDing.text isEqualToString:[langSetting localizedString:@"Select Date"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select Date"]];
        return;
    }
    //市别选择
    UILabel *lblShiBie = (UILabel *)[self.view viewWithTag:203];
    if ([lblShiBie.text isEqualToString:[langSetting localizedString:@"Select Market"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select Market"]];
        return;
    }
    //时间选择
    UILabel *lblShijian = (UILabel *)[self.view viewWithTag:204];
    if ([lblShijian.text isEqualToString:[langSetting localizedString:@"Select Time"]]) {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Select Time"]];
        return;
    }
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",strYuDingRiQi,strShijian];
    if ([self nowTime:timeStr]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:lblCity.text forKey:@"city"];
        [dic setObject:dicStore forKey:@"Store"];
        [dic setObject:lblYuDing.text forKey:@"targetDate"];
        [dic setObject:lblShiBie.text forKey:@"shiBie"];
        [dic setObject:lblShijian.text forKey:@"Date"];
//        privilegeViewController *book = [[privilegeViewController alloc] init];
        BSBookViewController *book = [[BSBookViewController alloc] init];
        book.dicInfo = dic;
        [self.navigationController pushViewController:book animated:YES];
    }else{
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"timeout"] delegate:self cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        });
        
    }
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
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.tag=10000;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        pickView.frame = CGRectMake(0, vPicker.frame.size.height-218, ScreenWidth, 218) ;
    }else{
        pickView.frame = CGRectMake(0, vPicker.frame.size.height-218-18, ScreenWidth, 218) ;
    }
    pickView.showsSelectionIndicator = YES;
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor whiteColor];
    
    [vPicker addSubview:pickView];
    
    vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    [self.view addSubview:vPicker];
    
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, 0, vPicker.frame.size.width, vPicker.frame.size.height);
    }];
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
    
    //预定日期
    UILabel *lblYuDing = (UILabel *)[self.view viewWithTag:202];
    lblYuDing.frame = CGRectMake(200, 20, 90, 20);
    
    NSString *stingDay=[NSString stringWithFormat:@"%d",selectDay];
    if(selectDay<10)
    {
        stingDay=[NSString stringWithFormat:@"0%d",selectDay];
    }
    NSString *stingMoon=[NSString stringWithFormat:@"%d",selectMoon];
    if(selectMoon<10)
    {
        stingMoon=[NSString stringWithFormat:@"0%d",selectMoon];
    }
    strYuDingRiQi = [NSString stringWithFormat:@"%d-%@-%@",selectYear,stingMoon,stingDay];
    lblYuDing.text= strYuDingRiQi;
    isTime=YES;
}

#pragma mark pickViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(flag==1)
    {
        strCity = [_dataCity objectAtIndex:row];
        strCityCode = [_dataCityCode objectAtIndex:row];
    }else if(flag==3)
    {
        strShiBie = [_dataSession objectAtIndex:row];
    }else if (flag == 4){
        if ([strShiBie isEqualToString:@"午市"]) {
            strShijian = [aryWuDate objectAtIndex:row];
        }else{
            strShijian = [aryYeDate objectAtIndex:row];
        }
    }
    else if(flag == 2){
        if(component==0)
        {
            selectYear =[[_dataYear objectAtIndex:row]integerValue];
            [(UIPickerView *)[self.view viewWithTag:10000] reloadAllComponents];
        }
        else if(component==1)
        {
            selectMoon=[[_dataMoon objectAtIndex:row]integerValue];
               [(UIPickerView *)[self.view viewWithTag:10000] reloadAllComponents];
        }
        else
        {
            selectDay=[[_dataDay objectAtIndex:row]integerValue];
        }
        
    }
   
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(flag == 1)
    {
        return [_dataCity count];
    }
    else if(flag == 3)
    {
        return [_dataSession count];
    }else if (flag == 4){
        if ([strShiBie isEqualToString:@"午市"]) {
            return [aryWuDate count];
        }else{
            return [aryYeDate count];
        }
    }else{
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
            selectMoon=[[_dataMoon objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
            _dataDay=[[NSMutableArray alloc]init];
            NSInteger   dayNum=1;
            if([NowMoon integerValue]==selectMoon)
            {
                dayNum=[NowDay integerValue];
            }
            for(int i=dayNum;i<=MoonDay;i++)
            {
                [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        return [_dataDay count];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(flag == 2)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(flag == 1)
    {
        return [_dataCity objectAtIndex:row];
    }
    else if(flag == 3)
    {
        return [_dataSession objectAtIndex:row];
    }else if (flag == 4){
        if ([strShiBie isEqualToString:@"午市"]) {
            return [aryWuDate objectAtIndex:row];
        }else{
            return [aryYeDate objectAtIndex:row];
        }
    }else
    {
        if(component==0)
        {
            selectYear=[[_dataYear objectAtIndex:row]integerValue ];
            return [_dataYear objectAtIndex:row];
        }
        else if (component==1)
        {
            selectMoon=[[_dataMoon objectAtIndex:row]integerValue ];
            return [_dataMoon objectAtIndex:row];
        }
        else
        {
            selectDay=[[_dataDay objectAtIndex:row]integerValue ];
            return [_dataDay objectAtIndex:row];
        }
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

-(void)initArray
{
    _dataCity =[[NSMutableArray alloc]init];
    _dataCityCode =[[NSMutableArray alloc]init];
//    [SVProgressHUD showWithStatus:nil maskType:SSVProgressHUDMaskTypeBlack];
//    [NSThread detachNewThreadSelector:@selector(getCity) toTarget:self withObject:nil];
    
    _dataSession=[[NSMutableArray alloc]initWithObjects:[langSetting localizedString:@"Select Market"],@"午市",@"夜市", nil];
    aryYeDate = [[NSMutableArray alloc] initWithObjects:[langSetting localizedString:@"Select Time"],@"16:00",@"16:15",@"16:30",@"16:45",@"17:00",@"17:15",@"17:30",@"17:45", nil];
    
    aryWuDate = [[NSMutableArray alloc] initWithObjects:[langSetting localizedString:@"Select Time"],@"13:30",@"13:45",@"14:00", nil];
//    NSArray *dataAllMessage=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist" ]];
//    for (NSDictionary *dict in dataAllMessage)
//    {
//        [_dataCity addObject:[dict objectForKey:@"state"]];
//    }
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*24;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间
    yy = [dateFormatter stringFromDate:localeDate];
    
    [dateFormatter setDateFormat:@"MM"];
    //用[NSDate date]可以获取系统当前时间
    MM = [dateFormatter stringFromDate:localeDate];
    NowMoon=MM;
    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
    dd = [dateFormatter stringFromDate:localeDate];
    NowDay=dd;
    _dataMoon=[[NSMutableArray alloc]init];
    _dataDay=[[NSMutableArray alloc]init];
    _dataYear=[[NSMutableArray alloc]initWithObjects:yy, nil];
    for(int i=[MM integerValue];i<=12;i++)
    {
        [_dataMoon addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=[dd integerValue];i<=31;i++)
    {
        [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

-(void)getCity{
    @autoreleasepool {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dicCity = [dp getCity];
        if ([[dicCity objectForKey:@"Result"] boolValue]) {
            NSArray *ary = [dicCity objectForKey:@"Message"];
            [_dataCity addObject:[langSetting localizedString:@"Select City"]];
            [_dataCityCode addObject:@""];
            for (NSDictionary *dic in ary) {
                [_dataCity addObject:[dic objectForKey:@"des"]];
                [_dataCityCode addObject:[dic objectForKey:@"sno"]];
                [SVProgressHUD dismiss];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[dicCity objectForKey:@"Message"]];
        }
    }
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

#pragma mark - registerViewControllerDelegate
//城市
-(void)setpro:(changeCity *)pro
{
    UILabel *lblPro = (UILabel *)[self.view viewWithTag:200];
    lblPro.text=pro.selectprovice;
    strCityCode = pro.selectproviceId;
    
    //城市
    UILabel *lblCity = (UILabel *)[self.view viewWithTag:200];
    
    //门店，如果城市改变，门店清空
    UILabel *lblStore = (UILabel *)[self.view viewWithTag:201];
    if (![lblCity.text isEqualToString:strCity]) {
        lblStore.text=[langSetting localizedString:@"Select Stores"];
        isMendian=NO;
    }
    
    if (strCity == nil) {
        if ([_dataCity count] > 0) {
            lblCity.text= [_dataCity objectAtIndex:1];
            strCityCode = [_dataCityCode objectAtIndex:1];
        }
    }else{
        lblCity.text= strCity;
    }
    isCity=YES;
}
//市别
-(void)setShiBie:(NSString *)shiBie
{
    UILabel *lblShiBie = (UILabel *)[self.view viewWithTag:203];
    //如果更改了市别，清空时间
    UILabel *lblShijian = (UILabel *)[self.view viewWithTag:204];
    if (![lblShiBie.text isEqualToString:shiBie]) {
        lblShijian.text = [langSetting localizedString:@"Select Time"];
    }
    
    lblShiBie.text=shiBie;
    DataProvider *dp= [DataProvider sharedInstance];
    dp.selectCanCi=shiBie;
    isShiBie=YES;
    
    NSLog(@"%@",dicStore);
    if([dp.selectCanCi isEqualToString:@"午市"])
    {
        dp.StartTime=[dicStore objectForKey:@"lunchstart"];
        dp.EndTime=[dicStore objectForKey:@"lunchendtime"];
    }
    else
    {
        dp.StartTime=[dicStore objectForKey:@"dinnerstart"];
        dp.EndTime=[dicStore objectForKey:@"dinnerendtime"];
    }

}
//时间
-(void)setTime:(NSString *)time
{
    UILabel *lblShijian = (UILabel *)[self.view viewWithTag:204];
    lblShijian.text = time;
    strShijian = time;
    isDate=YES;
}

@end
