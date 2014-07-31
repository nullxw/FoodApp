//
//  MenuViewController.m
//  Food
//
//  Created by sundaoran on 14-3-28.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "NewMenuViewController.h"
#import "WaitViewController.h"
#import "YuDingViewController.h"
#import "otherSetViewController.h"
#import "BookingViewController.h"
#import "FreeClickViewController.h"
#import "privilegeViewController.h"
#import "queueViewController.h"
#import "VipMainViewController.h"
#import "shopViewController.h"
#import "CheckMapViewController.h"
#import "AreaViewController.h"
#import "WebImageView.h"
#import "WebwebView.h"
#import "CycleScrollView.h"
#import "StarSelectCityViewController.h"

@interface NewMenuViewController ()

@end

#define SELFVIEWWEATH    self.view.bounds.size.width
#define SELFVIEWHEIGHT      self.view.bounds.size.height
#define MyYudingButton      101
#define MyWaitButton        102



@implementation NewMenuViewController
{
    UIView *_background;
    CGFloat   VIEWHEIGHT;
    
    BMKMapView          *_mapView;
    BMKSearch           *_search;
    
    CVLocalizationSetting   *langSetting;
    
    CycleScrollView *mainScorllView;
    UIScrollView *OnePic;
    UIPageControl *pageControll;
    
    UIImageView     *_loadAdView;
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
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate=nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    langSetting=[CVLocalizationSetting sharedInstance];
    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat     buttonHeight;//底部俩个按键的y坐标
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
        VIEWHEIGHT=64;
        buttonHeight=50;
        //    系统自带手势返回
        //        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        VIEWHEIGHT=44;
        buttonHeight=70;
    }
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    UIImageView *imageViewTitle=[[UIImageView alloc]init];
//    imageViewTitle.backgroundColor=selfbackgroundColor;
    imageViewTitle.backgroundColor=[UIColor colorWithRed:255/255.0f green:243/255.0f blue:143/255.0f alpha:1];
    imageViewTitle.frame=CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHEIGHT);
    [self.view addSubview:imageViewTitle];
    
    UIImageView *choice=[[UIImageView alloc]init];
    [choice setImage:[UIImage imageNamed:@"Menu_logo.png"]];
    choice.frame=CGRectMake(0, imageViewTitle.frame.size.height-44, SUPERVIEWWIDTH, 44);
    [imageViewTitle addSubview:choice];
    
    _mapView = [[BMKMapView alloc]init];
    [_mapView setShowsUserLocation:YES];
    
    
    //    用于地理编码和反编码
    _search = [[BMKSearch alloc]init];
    
    _background=[[UIView alloc]initWithFrame:CGRectMake(0, VIEWHEIGHT, ScreenWidth, ScreenHeight-(imageViewTitle.frame.origin.y+imageViewTitle.frame.size.height))];
    [_background setBackgroundColor:[UIColor clearColor]];
    [imageView addSubview:_background];
    
    
    UIButton *MyYuding=[UIButton buttonWithType:UIButtonTypeCustom];
    MyYuding.tag=MyYudingButton;
    MyYuding.frame=CGRectMake(0, _background.frame.size.height-buttonHeight, SELFVIEWWEATH, 50);
    [MyYuding addTarget:self action:@selector(ViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [MyYuding setTitle:[langSetting localizedString:@"My reservation"] forState:UIControlStateNormal];
    MyYuding.titleLabel.font=[UIFont systemFontOfSize:13];
    [MyYuding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [MyYuding setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1]];
    
    MyYuding.layer.borderWidth=0.5;
    MyYuding.layer.borderColor=selfborderColor.CGColor;
    [_background addSubview:MyYuding];
    UIImageView *yudingLeft=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Menu_reserve.png"]];
    yudingLeft.frame=CGRectMake(MyYuding.center.x-50, 15, 20, 20);
    [MyYuding addSubview:yudingLeft];
    
    for (int i=0; i<6; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(((SELFVIEWWEATH-150)/3+40)*(i%3)+35, (210-34)+(i/3)*((SELFVIEWWEATH-150)/3+40),(SELFVIEWWEATH-150)/3 ,(SELFVIEWWEATH-150)/3);
        button.tag=i+1000+1;
        [button addTarget:self action:@selector(MenuSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Menu_newmenu%d.png",i+1]] forState:UIControlStateNormal];
        [_background addSubview:button];
        
        UILabel *lbltitle=[[UILabel alloc]init];
        lbltitle.frame=CGRectMake(button.frame.origin.x,button.frame.origin.y+button.frame.size.height+10, button.frame.size.width, 20);
        lbltitle.backgroundColor=[UIColor clearColor];
        lbltitle.font=[UIFont boldSystemFontOfSize:12];
        lbltitle.textAlignment=NSTextAlignmentCenter;
        lbltitle.textColor=[UIColor blackColor];
        switch (i)
        {
            case 0:
                lbltitle.text=[langSetting localizedString:@"Online booking"];//@"在线订位";
                break;
            case 1:
                lbltitle.text=[langSetting localizedString:@"Preferential information"];//@"优惠信息";
                break;
            case 2:
                lbltitle.text=[langSetting localizedString:@"Customer reviews"];//@"顾客点评";
                break;
            case 3:
                lbltitle.text=[langSetting localizedString:@"Store the query"];//@"店铺查询";
                break;
            case 4:
                lbltitle.text=[langSetting localizedString:@"Look at the map"];//@"查看地图";
                break;
            case 5:
                lbltitle.text=[langSetting localizedString:@"Other Settings"];//@"其他设置";
                break;
                
            default:
                break;
        }
        [_background addSubview:lbltitle];
    }
    
    
    [self addScrollView:[self getCacheAdPic] andIsFirst:YES];
    
    [NSThread detachNewThreadSelector:@selector(findPic) toTarget:self withObject:nil];
    
}

-(NSMutableArray *)getCacheAdPic
{
    NSMutableArray *indexArray=[[NSMutableArray alloc]init];
    NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ads"] ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:localPath error:nil];
    for (NSString *str in fileArray)
    {
        NSString *filePath = [localPath stringByAppendingPathComponent:str];
        NSData *data=[[NSData alloc]initWithContentsOfFile:filePath];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:filePath,@"path",data,@"data", nil];
        [indexArray addObject:dict];
    }
    if([indexArray count]<=0)
    {
        _loadAdView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
        [_loadAdView setImage:[UIImage imageNamed:@"ad_logoPng.png"]];
    }
    return indexArray;
}

-(void)findPic
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp findPic];
        NSMutableArray *indexArrayResult;
        if([[dict objectForKey:@"Result"]boolValue])
        {
            indexArrayResult=[[NSMutableArray alloc]initWithArray:[[dict objectForKey:@"Message"]componentsSeparatedByString:@"," ]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([indexArrayResult count]!=0)
                {
                    [self addScrollView:indexArrayResult andIsFirst:NO];
                }
            });
        }
    }
}

-(void)addScrollView:(NSMutableArray *)array andIsFirst:(BOOL)isFirst
{
    NSMutableArray  *viewsArray=[[NSMutableArray alloc]init];//广告图片
    if(isFirst)
    {
        for (int i = 0; i < [array count]; ++i)
        {
            NSDictionary *dict=[array objectAtIndex:i];
            NSString *imageType = [[[dict objectForKey:@"path"] componentsSeparatedByString:@"."]lastObject];
            
            //        判断是否为gif格式的动画
            if([imageType isEqualToString:@"gif"])
            {
                WebwebView *webView=[[WebwebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
                [webView loadData:[dict objectForKey:@"data"] MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                [viewsArray addObject:webView];
            }
            else
            {
                WebImageView *imageView = [[WebImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
                [imageView setImage:[UIImage imageWithData:[dict objectForKey:@"data"]]];
                [viewsArray addObject:imageView];
            }
            
        }
        
    }
    else
    {
        for (int i = 0; i < [array count]; ++i)
        {
            if(_loadAdView)
            {
                [_loadAdView removeFromSuperview];
                _loadAdView=nil;
            }
            
            NSString *url=[array objectAtIndex:i];
            NSString *imageType = [[url componentsSeparatedByString:@"."]lastObject];
            NSMutableDictionary *dictImage=[[NSMutableDictionary alloc]init];
            
            //        判断是否为gif格式的动画
            if([imageType isEqualToString:@"gif"])
            {
                NSString *path=[[NSBundle mainBundle]pathForResource:@"ad_logoGif" ofType:@"gif" ];
                NSData *data=[NSData dataWithContentsOfFile:path];
                WebwebView *webView=[[WebwebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
                webView.scrollView.scrollEnabled=NO;
                [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                [dictImage setObject:webView forKey:@"imageView"];
                [dictImage setObject:url forKey:@"url"];
                [dictImage setObject:[NSNumber numberWithBool:YES] forKey:@"gif"];
                [self getImage:dictImage];
                //                [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:dictImage];
                [viewsArray addObject:webView];
            }
            else
            {
                WebImageView *imageView = [[WebImageView alloc] initWithImage:[UIImage imageNamed:@"ad_logoPng.png"]];
                //                WebImageView *imageView = [[WebImageView alloc] init];
                
                imageView.frame=CGRectMake(0, 0, ScreenWidth, 170);
                [dictImage setObject:imageView forKey:@"imageView"];
                [dictImage setObject:url forKey:@"url"];
                [dictImage setObject:[NSNumber numberWithBool:NO] forKey:@"gif"];
                [self getImage:dictImage];
                //                [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:dictImage];
                
                [viewsArray addObject:imageView];
            }
        }
        
    }
    if(mainScorllView)
    {
        [mainScorllView removeFromSuperview];
        mainScorllView =nil;
    }
    if(pageControll)
    {
        [pageControll removeFromSuperview];
        pageControll=nil;
    }
    if([viewsArray count]==1)
    {
        OnePic=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
        [OnePic addSubview:[viewsArray firstObject]];
        OnePic.backgroundColor=[UIColor clearColor];
        OnePic.contentOffset=CGPointMake(0, 0);
        [_background addSubview:OnePic];
        
        pageControll=[[UIPageControl alloc]initWithFrame:CGRectMake(0, OnePic.frame.origin.y+OnePic.frame.size.height-40, ScreenWidth, 40)];
        pageControll.numberOfPages=[viewsArray count];
        pageControll.currentPageIndicatorTintColor=selfbackgroundColor;
        pageControll.pageIndicatorTintColor=[UIColor grayColor];
        pageControll.userInteractionEnabled=NO;
        [_background addSubview:pageControll];
        
        if(_loadAdView)
        {
            [_background addSubview:_loadAdView];
        }
    }
    else
    {
        mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170) animationDuration:10];
        mainScorllView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        mainScorllView.scrollView.showsHorizontalScrollIndicator=NO;
        [_background addSubview:mainScorllView];
        
        pageControll=[[UIPageControl alloc]initWithFrame:CGRectMake(0, mainScorllView.frame.origin.y+mainScorllView.frame.size.height-40, ScreenWidth, 40)];
        pageControll.numberOfPages=[viewsArray count];
        pageControll.currentPageIndicatorTintColor=selfbackgroundColor;
        pageControll.pageIndicatorTintColor=[UIColor grayColor];
        pageControll.userInteractionEnabled=NO;
        [_background addSubview:pageControll];
        
        
        UIPageControl *__block pageControllIndex=pageControll;
        mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            pageControllIndex.currentPage=pageIndex;
            return viewsArray[pageIndex];
        };
        mainScorllView.totalPagesCount = ^NSInteger(void){
            return [viewsArray count];
        };
        mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%d个",pageIndex);
        };
        //    判断是否有广告图片，没有则加载默认的图片
        if(_loadAdView)
        {
            [_background addSubview:_loadAdView];
            [mainScorllView removeFromSuperview];
            mainScorllView=nil;
            [pageControll removeFromSuperview];
            pageControll=nil;
        }
    }
    
}
#pragma mark  cache
//获取图片路径
-(void)getImage:(NSMutableDictionary *)dict
{
    @autoreleasepool {
        NSString *url=[NSString stringWithFormat:@"%@%@#ads",[[DataProvider getIpPlist]objectForKey:@"adPicURL"],[dict objectForKey:@"url"]];
        //        通过文件后缀含有ads判断缓存文件为广告文件，将广告文件单独缓存在一个文件夹下
        if([[dict objectForKey:@"gif"]boolValue])
        {
            WebwebView *webView=[dict objectForKey:@"imageView"];
            if([self imageCache:url])
            {
                [webView loadData:[self imageCache:url] MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            }
            else
            {
                [webView setImageURL:[NSURL URLWithString:url]];
            }
        }
        else
        {
            WebImageView *imageView=[dict objectForKey:@"imageView"];
            if([self imageCache:url])
            {
                [imageView setImage:[UIImage imageWithData:[self imageCache:url]]];
            }
            else
            {
                [imageView setImageURL:[NSURL URLWithString:url] andImageBoundName:@"ad_logoPng.png"];
            }
        }
    }
}


-(NSData *)imageCache:(NSString *)url //判断缓存中是否存在文件
{
    
    //    广告图片缓存在沙盒下的ads文件夹下
    NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/ads"] ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePathgif=[localPath stringByAppendingString:[NSString stringWithFormat:@"/%@.gif",[DataProvider md5:url]]];
    NSString *filePathpng=[localPath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",[DataProvider md5:url]]];
    
    if([fileManager fileExistsAtPath:filePathgif])
    {
        NSData *data=[fileManager contentsAtPath:filePathgif];
        return data;
    }
    else if([fileManager fileExistsAtPath:filePathpng])
    {
        NSData *data=[fileManager contentsAtPath:filePathpng];
        return data;
    }
    else
    {
        return nil;
    }
}



//位置发生改变时获取当前的经纬度
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [DataProvider sharedInstance].latitude=userLocation.location.coordinate.latitude;
        [DataProvider sharedInstance].longitude=userLocation.location.coordinate.longitude;
	}
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
	if (userLocation.location.coordinate.latitude && userLocation.location.coordinate.longitude)
    {
		pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
	}
	BOOL flag = [_search reverseGeocode:pt];
	if (flag) {
		NSLog(@"ReverseGeocode search success.");
        //        定位成功后通知定位
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = NO;
	}
    else{
        NSLog(@"ReverseGeocode search failed!");
    }
}

//定位编码返回结果通知方法
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == 0)
    {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.title = result.addressComponent.city;
        item.subtitle=result.strAddr;
        [DataProvider sharedInstance].localCity= [NSString stringWithFormat:@"%@",item.title];
        [DataProvider sharedInstance].localAddr=[NSString stringWithFormat:@"%@",result.strAddr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refushLocal" object:nil];
        NSLog(@"定位成功====%@",[DataProvider sharedInstance].localCity);
	}
}


-(void)MenuSelectClick:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    NSInteger index=button.tag%1000;
    
    if(1==index)
    {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ] && [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
        {
            
            BookingViewController *book=[[BookingViewController alloc]init];
            [self.navigationController pushViewController:book animated:YES];//在线预点
            [DataProvider sharedInstance].isReserveis=YES;
            [DataProvider sharedInstance].tableId=nil;
        }
        else
        {
            //请先绑定手机号码和完善个人信息
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number and improve the personal information"]];
        }
    }
    else if(2==index)
    {
        AreaViewController *favor=[[AreaViewController alloc]init];//优惠信息
        [self.navigationController pushViewController:favor animated:YES];
    }
    else if(3==index)
    {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ] && [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
        {
            StarSelectCityViewController *strar=[[StarSelectCityViewController alloc]init];//用户点评
            [self.navigationController pushViewController:strar animated:YES];
        }
        else
        {
            //请先绑定手机号码和完善个人信息
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number and improve the personal information"]];
        }
    }
    else if(4==index)
    {
        shopViewController *shop=[[shopViewController alloc]init];//店铺查询
        [self.navigationController pushViewController:shop animated:YES];
    }
    else if(5==index)
    {
        CheckMapViewController *check=[[CheckMapViewController alloc]init];//查看地图
        [self.navigationController pushViewController:check animated:YES];
    }
    else if (6==index)
    {
        otherSetViewController *otherView=[[otherSetViewController alloc]init];//其他设置
        [self.navigationController pushViewController:otherView animated:YES];
    }
    else
    {
        NSLog(@"无此选项"); 
    }
}

-(void)ViewButtonClick:(UIButton *)button
{
    YuDingViewController *yuding=[[YuDingViewController alloc]init];
    [self.navigationController pushViewController:yuding animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
