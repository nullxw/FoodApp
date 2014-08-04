//
//  BookingViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "BookingViewController.h"
#import "showTableViewController.h"
#import "MakeSureTableViewController.h"

@implementation BookingViewController
{
    UIView              *_backGround;
    UIView              *vPicker;
    CGFloat             VIEWHRIGHT;
    
    UILabel             *_lblchangeCity;
    UILabel             *_lblchangeTime;
    UILabel             *_lblchangeSession;
    UILabel             *_lblchangeBrand;
    
    
    UIPickerView        *_pickViewTime;
    
    NSMutableArray      *_dataCity;
    NSMutableArray      *_dataSession;
    NSMutableArray      *_dataYear;
    NSMutableArray      *_dataMoon;
    NSMutableArray      *_dataDay;
    
    
    NSInteger           selectYear;
    NSInteger           selectMoon;
    NSInteger           selectDay;
    
    NSString            *NowMoon;  //当前月份
    NSString            *NowDay;    //当前日
    NSString            *_selectBrank;//选择的品牌
    
    CVLocalizationSetting   *langSetting;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    //每次初始化单例值方便判断是否已选择该选择项
    DataProvider *dataprovider=[DataProvider sharedInstance];
    dataprovider.selectCanCi=@"";
    dataprovider.selectOnlyCity=@"";
    dataprovider.selectTime=@"";
    _selectBrank=@"";//初始化品牌选择呢
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Online booking"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
    [self initArray];
    
    
    UIImageView *imageViewLeft;
    
    UIImageView *imgJianTou;
    
    UILabel     *lblLeft;
    
    UIButton *changeCity=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeCity setBackgroundColor:[UIColor whiteColor]];
    changeCity.frame=CGRectMake(10, 20, SUPERVIEWWIDTH-20, 60);
    changeCity.layer.cornerRadius=5.0;
    changeCity.tag=101;
    changeCity.layer.borderColor=selfborderColor.CGColor;
    changeCity.layer.borderWidth=0.5;
    [changeCity  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_City.png"]];
    [changeCity addSubview:imageViewLeft];
    
    imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(changeCity.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [changeCity addSubview:imgJianTou];
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:[langSetting localizedString:@"city"]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [changeCity addSubview:lblLeft];
    
    
    _lblchangeCity=[[UILabel alloc]init];
    _lblchangeCity.frame=CGRectMake(0, 0, changeCity.frame.size.width-60, 60);
    [_lblchangeCity setText:[langSetting localizedString:@"Select City"]];
    _lblchangeCity.textAlignment=NSTextAlignmentRight;
    _lblchangeCity.backgroundColor=[UIColor clearColor];
    _lblchangeCity.font=[UIFont systemFontOfSize:13];
    [_lblchangeCity setTextColor:[UIColor blackColor]];
    [changeCity addSubview:_lblchangeCity];
    [_backGround addSubview:changeCity];
    
    
    UIButton *changeTime=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeTime setBackgroundColor:[UIColor whiteColor]];
    changeTime.frame=CGRectMake(10, changeCity.frame.origin.y+70, SUPERVIEWWIDTH-20, 60);
    [changeTime setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    changeTime.layer.cornerRadius=5.0;
    changeTime.tag=102;
    changeTime.layer.borderColor=selfborderColor.CGColor;
    changeTime.layer.borderWidth=0.5;
    [changeTime  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_date.png"]];
    [changeTime addSubview:imageViewLeft];
    imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(changeTime.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [changeTime addSubview:imgJianTou];
    
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:[langSetting localizedString:@"A due date"]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [changeTime addSubview:lblLeft];
    
    _lblchangeTime=[[UILabel alloc]init];
    _lblchangeTime.frame=CGRectMake(0, 0, changeCity.frame.size.width-60, 60);
    [_lblchangeTime setText:[self nowTime]];
    _lblchangeTime.textAlignment=NSTextAlignmentRight;
    _lblchangeTime.backgroundColor=[UIColor clearColor];
    _lblchangeTime.font=[UIFont systemFontOfSize:13];
    [_lblchangeTime setTextColor:[UIColor blackColor]];
    [changeTime addSubview:_lblchangeTime];
    [_backGround addSubview:changeTime];
    
    //    初始化时间，默认当前日期
    [DataProvider sharedInstance].selectTime=[self nowTime];
    
    UIButton *changeSession=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeSession setBackgroundColor:[UIColor whiteColor]];
    changeSession.frame=CGRectMake(10, changeTime.frame.origin.y+70, SUPERVIEWWIDTH-20, 60);
    changeSession.layer.cornerRadius=5.0;
    changeSession.tag=103;
    changeSession.layer.borderColor=selfborderColor.CGColor;
    changeSession.layer.borderWidth=0.5;
    [changeSession  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_meal.png"]];
    [changeSession addSubview:imageViewLeft];
    imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(changeSession.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [changeSession addSubview:imgJianTou];
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:[langSetting localizedString:@"market"]];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [changeSession addSubview:lblLeft];
    
    _lblchangeSession=[[UILabel alloc]init];
    _lblchangeSession.frame=CGRectMake(0, 0, changeSession.frame.size.width-60, 60);
    [_lblchangeSession setText:[langSetting localizedString:@"Select Market"]];
    _lblchangeSession.textAlignment=NSTextAlignmentRight;
    _lblchangeSession.backgroundColor=[UIColor clearColor];
    _lblchangeSession.font=[UIFont systemFontOfSize:13];
    [_lblchangeSession setTextColor:[UIColor blackColor]];
    [changeSession addSubview:_lblchangeSession];
    [_backGround addSubview:changeSession];
    
    
    UIButton *changeBrank=[UIButton buttonWithType:UIButtonTypeCustom];
    [changeBrank setBackgroundColor:[UIColor whiteColor]];
    changeBrank.frame=CGRectMake(10, changeSession.frame.origin.y+70, SUPERVIEWWIDTH-20, 60);
    changeBrank.layer.cornerRadius=5.0;
    changeBrank.tag=105;
    changeBrank.layer.borderColor=selfborderColor.CGColor;
    changeBrank.layer.borderWidth=0.5;
    [changeBrank  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_meal.png"]];
    [changeBrank addSubview:imageViewLeft];
    imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(changeSession.frame.size.width-20, 20, 20, 20)];
    [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
    [changeBrank addSubview:imgJianTou];
    
    lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,70, 60);
    [lblLeft setText:@"品       牌"];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:17];
    [lblLeft setTextColor:[UIColor blackColor]];
    [changeBrank addSubview:lblLeft];
    
    _lblchangeBrand=[[UILabel alloc]init];
    _lblchangeBrand.frame=CGRectMake(0, 0, changeSession.frame.size.width-60, 60);
    [_lblchangeBrand setText:@"选择品牌"];
    _lblchangeBrand.textAlignment=NSTextAlignmentRight;
    _lblchangeBrand.backgroundColor=[UIColor clearColor];
    _lblchangeBrand.font=[UIFont systemFontOfSize:13];
    [_lblchangeBrand setTextColor:[UIColor blackColor]];
    [changeBrank addSubview:_lblchangeBrand];
    [_backGround addSubview:changeBrank];
    
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, SUPERVIEWHEIGHT-160, SUPERVIEWWIDTH-20, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    nextButton.tag=104;
    [nextButton  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Next step"]];
    netlbl.textAlignment=NSTextAlignmentCenter;
    netlbl.backgroundColor=[UIColor clearColor];
    netlbl.font=[UIFont systemFontOfSize:13];
    [netlbl setTextColor:[UIColor whiteColor]];
    [nextButton addSubview:netlbl];
    [_backGround addSubview:nextButton];
    
    
    UIControl *control=[[UIControl alloc]initWithFrame:_backGround.frame];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:control];
    [_backGround sendSubviewToBack:control];
    
    
}

-(void)changeButtonClick:(UIButton *)button
{
    if(101==button.tag)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectOnlyCity andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
        
    }
    else if(102==button.tag)
    {
        [self showPickView];
    }
    else if(103==button.tag)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectShiBie andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
    }
    else if(104==button.tag)
    {
        DataProvider *provider=[DataProvider sharedInstance];
        if([provider.selectOnlyCity isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"你还未选择城市"];
        }
        else if ([provider.selectTime isEqualToString:@""])
        {
            
            [SVProgressHUD showErrorWithStatus:@"你还未选择日期"];
        }
        else if ([provider.selectCanCi isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"你还未选择餐次"];
        }
        else if([_selectBrank isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"你还未选择品牌"];
        }
        else
        {
            showTableViewController *show=[[showTableViewController alloc]init];
            [self.navigationController pushViewController:show animated:YES];
            //        MakeSureTableViewController *make=[[MakeSureTableViewController alloc]init];
            //        [self.navigationController pushViewController:make animated:YES];
        }
    }
    else if(105==button.tag)
    {
        typeSelectViewViewController *typeView=[[typeSelectViewViewController alloc]initWithViewType:viewSelectBrank andName:nil];
        typeView.delegate=self;
        UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:typeView];
        nvc.navigationBar.hidden=YES;
        nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
        
        typeView.selectBrank=^(NSMutableDictionary *BrankName)
        {
            _lblchangeBrand.text=[BrankName objectForKey:@"name"];
            _selectBrank=[BrankName objectForKey:@"name"];
            [DataProvider sharedInstance].selectBrank=[BrankName objectForKey:@"code"];
        };
      
    }
    else
    {
        NSLog(@"BookingView dont'have this click");
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
    
    _lblchangeTime.text=[NSString stringWithFormat:@"%ld-%@-%@",(long)selectYear,stingMoon,stingDay];
    
    [DataProvider sharedInstance].selectTime=_lblchangeTime.text;
}


-(void)controlClick
{
    [_pickViewTime removeFromSuperview];
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
        NSInteger   dayNum=1;

        if([NowMoon integerValue]==selectMoon)
        {
            dayNum=[NowDay integerValue];//当前月份，日期从当前日期开始，否则，从1号开始
        }
        for(int i=dayNum;i<=MoonDay;i++)
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

-(void)initArray
{
    _dataCity =[[NSMutableArray alloc]init];
    _dataSession=[[NSMutableArray alloc]init];
    
    NSArray *dataAllMessage=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist" ]];
    for (NSDictionary *dict in dataAllMessage)
    {
        [_dataCity addObject:[dict objectForKey:@"state"]];
    }
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
    for(int i=[MM integerValue];i<=12;i++)
    {
        [_dataMoon addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=[dd integerValue];i<=31;i++)
    {
        [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}


#pragma mark  获取城市，时间代理
-(void)setTime:(NSString *)time
{
    _lblchangeTime.text=time;
    [DataProvider sharedInstance].selectTime=time;
}
-(void)setpro:(changeCity *)pro
{
    _lblchangeCity.text= pro.selectprovice;
    [DataProvider sharedInstance].selectOnlyCity=pro.selectprovice;
    [DataProvider sharedInstance].selectCity=pro;//包含身份名称和编码
}
-(void)setShiBie:(NSString *)shiBie
{
    _lblchangeSession.text=shiBie;
    [DataProvider sharedInstance].selectCanCi=shiBie;
}
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
