//
//  CheckMapViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "CheckMapViewController.h"


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation1 : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation1

@synthesize type = _type;
@synthesize degree = _degree;

@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end


@implementation CheckMapViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    BMKMapView          *_mapView;
    BMKSearch           *_search;
    
    NSMutableArray      *_buttonArray;
    NSMutableArray      *_dataArray;//门店数据
    NSMutableArray      *_PointAnnotationArray;//添加的门店标注物体
    NSMutableArray      *_phoneArray;
    StoreMessage        *_store;//选中的门店
    
    UIView              *_mapTypeView;//选择地图显示类型的view
    BOOL                isShowChangeType;
    BOOL                isPost; //是否开始请求数据
    CVLocalizationSetting *langSetting;

}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    _dataArray=nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate=nil;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}
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
    langSetting=[CVLocalizationSetting sharedInstance];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Look at the map"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor greenColor];
    [self.view addSubview:_backGround];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width,_backGround.frame.size.height-VIEWHRIGHT-44)];
    [_mapView setShowsUserLocation:YES];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_backGround addSubview:_mapView];
    
    _search = [[BMKSearch alloc]init];
    
    UIView  *toolBarView=[[UIView alloc]initWithFrame:CGRectMake(0, _mapView.frame.size.height, ScreenWidth, 44)];
    toolBarView.backgroundColor=selfbackgroundColor;
    _buttonArray=[[NSMutableArray alloc]init];
    for (int i=0; i<5; i++)
    {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(i*(ScreenWidth/5)+15, 5, ScreenWidth/5-30, toolBarView.frame.size.height-10);
        button.tag=1000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
            {
                [button setBackgroundImage:[UIImage imageNamed:@"Map_BusNomal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Map_BusSelect.png"] forState:UIControlStateHighlighted];
            }break;
            case 1:
            {
                [button setBackgroundImage:[UIImage imageNamed:@"Map_carNomal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Map_carSelect.png"] forState:UIControlStateHighlighted];
            }break;
            case 2:
            {
                [button setBackgroundImage:[UIImage imageNamed:@"Map_localNomal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Map_localSelect.png"] forState:UIControlStateHighlighted];
                
            }break;
            case 3:
            {
                [button setBackgroundImage:[UIImage imageNamed:@"Map_walkNomal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Map_walkSelect.png"] forState:UIControlStateHighlighted];
            }break;
            case 4:
            {
                [button setBackgroundImage:[UIImage imageNamed:@"Map_changeStyleNomal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Map_changeStyleSelect.png"] forState:                   UIControlStateHighlighted];
            }
                break;
                
            default:
                break;
        }
        [_buttonArray addObject:button];
        [toolBarView addSubview:button];
    }
    [_backGround addSubview:toolBarView];
    
    _mapTypeView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-80, _backGround.frame.size.height-toolBarView.frame.size.height-144, 100, 80)];
    _mapTypeView.backgroundColor=[UIColor orangeColor];
    for (int i=0; i<2; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0,i*((_mapTypeView.frame.size.height)/2+1) ,80, ((_mapTypeView.frame.size.height)/2-4));
        if(i==0)
        {
            [button setTitle:[NSString stringWithFormat:@"平面地图"] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:[NSString stringWithFormat:@"实景地图"] forState:UIControlStateNormal];
        }
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        button.tag=2000+i;
        [button setBackgroundColor:selfbackgroundColor];
        [button addTarget:self action:@selector(mapTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mapTypeView addSubview:button];
    }

    
}
//改变地图类型事件
-(void)mapTypeClick:(UIButton *)button
{
    //    [_mapTypeView removeFromSuperview];
    if(button.tag==2000)
    {
        [_mapView setMapType:BMKMapTypeStandard];
    }
    else
    {
        [_mapView setMapType:BMKMapTypeSatellite];
    }
}

-(void)buttonClick:(UIButton *)button
{
    DataProvider *dp=[DataProvider sharedInstance];
    switch (button.tag)
    {
        case 1000:
        {
            if(isShowChangeType)
            {
                [_mapTypeView removeFromSuperview];
                isShowChangeType=NO;
            }
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            CLLocationCoordinate2D startlocation;
            startlocation.latitude=dp.latitude;
            startlocation.longitude=dp.longitude;
            start.pt=startlocation;
            BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
            CLLocationCoordinate2D endlocation;
            endlocation.latitude=dp.goallatitude;
            endlocation.longitude=dp.goallongitude;
            end.pt=endlocation;
            
            BOOL flag = [_search transitSearch:dp.localCity startNode:start endNode:end];            if (flag) {
                NSLog(@"search success.");
            }
            else{
                NSLog(@"search failed!");
            }
            
        }break;
        case 1001:
        {
            if(isShowChangeType)
            {
                [_mapTypeView removeFromSuperview];
                isShowChangeType=NO;
            }
             BMKPlanNode* start = [[BMKPlanNode alloc]init];
            CLLocationCoordinate2D startlocation;
            startlocation.latitude=dp.latitude;
            startlocation.longitude=dp.longitude;
            start.pt=startlocation;
            BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
            CLLocationCoordinate2D endlocation;
            endlocation.latitude=dp.goallatitude;
            endlocation.longitude=dp.goallongitude;
            end.pt=endlocation;
            BOOL flag = [_search drivingSearch:dp.localCity startNode:start endCity:dp.goalCity endNode:end];
            if (flag) {
                NSLog(@"search success.");
            }
            else{
                NSLog(@"search failed!");
            }
            
        }
            break;
        case 1002:
        {
            if(isShowChangeType)
            {
                [_mapTypeView removeFromSuperview];
                isShowChangeType=NO;
            }
            _mapView.showsUserLocation = NO;
            _mapView.userTrackingMode = BMKUserTrackingModeFollow;
            _mapView.showsUserLocation = YES;
            
        }break;
        case 1003:
        {
            if(isShowChangeType)
            {
                [_mapTypeView removeFromSuperview];
                isShowChangeType=NO;
            }
            
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            CLLocationCoordinate2D startlocation;
            startlocation.latitude=dp.latitude;
            startlocation.longitude=dp.longitude;
            start.pt=startlocation;
            BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
            CLLocationCoordinate2D endlocation;
            endlocation.latitude=dp.goallatitude;
            endlocation.longitude=dp.goallongitude;
            end.pt=endlocation;
            
            BOOL flag = [_search walkingSearch:dp.localCity startNode:start endCity:dp.goalCity endNode:end];
            
            if (flag) {
                NSLog(@"search success.");
            }
            else{
                NSLog(@"search failed!");
            }
            
            
        }break;
        case 1004:
        {
            
            if(isShowChangeType)
            {
                [_mapTypeView removeFromSuperview];
                isShowChangeType=NO;
            }
            else
            {
                [_backGround addSubview:_mapTypeView];
                isShowChangeType=YES;
            }
        }
            break;
    }
    
}


#pragma mark -----定位反编码

//位置发生改变时获取当前的经纬度
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [DataProvider sharedInstance].latitude=userLocation.location.coordinate.latitude;
        [DataProvider sharedInstance].longitude=userLocation.location.coordinate.longitude;
	}
    if(!isPost)//定位随时都在改变，如果数组有数据则不在调用查询门店的接口
    {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        if (userLocation.location.coordinate.latitude && userLocation.location.coordinate.longitude) {
            pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        }
        BOOL flag = [_search reverseGeocode:pt];
        if (flag) {
            NSLog(@"ReverseGeocode search success.");
            //        定位成功后通知定位
        }
        else{
            NSLog(@"ReverseGeocode search failed!");
        }
    }
}
//定位编码返回结果通知方法
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0)
    {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.title = result.addressComponent.city;
        item.subtitle=result.strAddr;
        [DataProvider sharedInstance].localCity= [NSString stringWithFormat:@"%@",item.title];
        [DataProvider sharedInstance].localAddr=[NSString stringWithFormat:@"%@",result.strAddr];
        NSLog(@"定位成功===>%@",[DataProvider sharedInstance].localCity);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refushLocal" object:nil];
           [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(getStore) toTarget:self withObject:nil];
	}
}

//获取门店数据
-(void)getStore
{
    @autoreleasepool {
        isPost=YES;
        DataProvider *dp=[DataProvider sharedInstance];
        dp.storeMessage=nil;
        NSMutableDictionary *dictValue=[[NSMutableDictionary alloc]init];
        
        if([dp.localCity rangeOfString:@"市"].location !=NSNotFound)//判断字符串中是否包含“市”字
        {
            dp.localCity=[dp.localCity substringWithRange:NSMakeRange(0, [dp.localCity length]-1)];
            
        }
        [dictValue setValue:dp.localCity forKey:@"area"];
        [dictValue setValue:@"1" forKey:@"type"];
        dp.isShop=YES;
        NSDictionary *dictStore=[[NSDictionary alloc]initWithDictionary:[dp getStoreByArea:dictValue]];
        
        if ([[dictStore objectForKey:@"Result"] boolValue])
        {
             [SVProgressHUD dismiss];
            if([_PointAnnotationArray count])//每次加载图标前移除所有的图标，防止重复添加
            {
                for (BMKPointAnnotation *point in _PointAnnotationArray) {
                    [_mapView removeAnnotation:point];
                }
            }
            NSArray *ary = [dictStore objectForKey:@"Message"];
            _dataArray=[[NSMutableArray alloc]init];
            _PointAnnotationArray=[[NSMutableArray alloc]init];
            _phoneArray=[[NSMutableArray alloc]init];
//            float i=0.01;
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
                store.lunchstart=[dic objectForKey:@"lunchstart"];
                store.lunchendtime=[dic objectForKey:@"lunchendtime"];
                store.dinnerstart=[dic objectForKey:@"dinnerstart"];
                store.dinnerendtime=[dic objectForKey:@"dinnerendtime"];
                
                store.storelongitude=[[[[dic objectForKey:@"position"]componentsSeparatedByString:@","]firstObject]doubleValue ];
                store.storelatitude=[[[[dic objectForKey:@"position"]componentsSeparatedByString:@","]lastObject]doubleValue ];
                
//               坐标经纬度
//                store.storelongitude=116.404+i;
//                i+=0.01;
//                store.storelatitude=39.915;
                [_dataArray addObject:store];
                [_mapView addAnnotation:[self addPointAnnotation:store]];
                [_PointAnnotationArray addObject:[self addPointAnnotation:store]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dictStore objectForKey:@"Message"]];
        }
    
    }
    
}


#pragma mark  BMKMapViewDelegate
//添加标注
- (BMKPointAnnotation*)addPointAnnotation:(StoreMessage *)store
{
   BMKPointAnnotation   *pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = store.storelatitude;
    coor.longitude = store.storelongitude;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title =store.storeFirmdes;
    pointAnnotation.subtitle=store.storeAddr;
    
//    用于判断选择的目标门店
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:store forKey:@"storeMessage"];
    [dict setObject:pointAnnotation forKey:@"annView"];
    [_phoneArray addObject:dict];
    
    return pointAnnotation;
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation1 class]]) {
		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation1*)annotation];
	}
    else
    {
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *newAnnotation;
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
//		((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"Public_tele.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(callPhonebuttobClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.text=((BMKPointAnnotation*)annotation).title;
        newAnnotation.rightCalloutAccessoryView=button;
    }
    return newAnnotation;
    }
    return nil;
}


//选择的标注信息
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    for (NSDictionary *value in _phoneArray)
    {
       if([value objectForKey:@"annView"]==view.annotation)
       {
           _store=[value objectForKey:@"storeMessage"];
           DataProvider *dp= [DataProvider sharedInstance];
           dp.goallatitude=_store.storelatitude;
           dp.goallongitude=_store.storelongitude;
           dp.goalAddr=_store.storeAddr;
           
       }
    }
}



-(void)callPhonebuttobClick:(UIButton *)button
{
    for (StoreMessage *store in _dataArray)
    {
        if([store.storeFirmdes isEqualToString:button.titleLabel.text])
        {
            [self.view addSubview:[DataProvider callPhoneOrtele:store.storeTele]];
            DataProvider *dp= [DataProvider sharedInstance];
            dp.goalAddr=store.storeAddr;
        }
    }
 
}


-(UIView *)callPhoneOrtele:(NSString *)phoneOrTele
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneOrTele]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    return callWebview;
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

#pragma mark  -----线路规划
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation1*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] ;
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}


- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

- (void)onGetTransitRouteResult:(BMKSearch*)searcher result:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	for (int i=0; i<[array count]; i++)
    {
        if([[array objectAtIndex:i]isKindOfClass:[RouteAnnotation1 class]])
        {
            [_mapView removeAnnotation:[array objectAtIndex:i]];
        }
    }
    array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    if (error == BMKErrorOk) {
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		RouteAnnotation1* item = [[RouteAnnotation1 alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"我的位置";
		item.type = 0;
		[_mapView addAnnotation:item]; // 添加起点标注
        
		item = [[RouteAnnotation1 alloc]init];
		item.coordinate = plan.endPt;
		item.type = 1;
		item.title = _store.storeFirmdes;
		[_mapView addAnnotation:item]; // 终点标注
		
        // 计算路线方案中的点数
		int size = [plan.lines count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			planPointCounts += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					planPointCounts += len;
				}
				break;
			}
		}
		
        // 构造方案中点的数组，用户构建BMKPolyline
		BMKMapPoint* points = new BMKMapPoint[planPointCounts];
		planPointCounts = 0;
		
        // 查询队列中的元素，构建points数组，并添加公交标注
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + planPointCounts, line.points, line.pointsCount * sizeof(BMKMapPoint));
			planPointCounts += line.pointsCount;
			
			item = [[RouteAnnotation1 alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item]; // 上车标注
			
			route = [plan.routes objectAtIndex:i+1];
			item = [[RouteAnnotation1 alloc]init];
			item.coordinate = line.getOffStopPoiInfo.pt;
			item.title = route.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			[_mapView addAnnotation:item]; // 下车标注
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
					planPointCounts += len;
				}
				break;
			}
		}
        
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []points;
        
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
	}
}

- (void)onGetDrivingRouteResult:(BMKSearch*)searcher result:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        for (int i=0; i<[array count]; i++)
        {
            NSLog(@"%@",[array objectAtIndex:i]);
            if([[array objectAtIndex:i]isKindOfClass:[RouteAnnotation1 class]])
            {
                [_mapView removeAnnotation:[array objectAtIndex:i]];
            }
        }
        
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation1* item = [[RouteAnnotation1 alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = [DataProvider sharedInstance].localAddr;
            item.type = 0;
            [_mapView addAnnotation:item];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation1 alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                    
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation1 alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title =_store.storeFirmdes;
            [_mapView addAnnotation:item];
            
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation1 alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                    
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}
- (void)onGetWalkingRouteResult:(BMKSearch*)searcher result:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    NSLog(@"%@",array);
	for (int i=0; i<[array count]; i++)
    {
        if([[array objectAtIndex:i]isKindOfClass:[RouteAnnotation1 class]])
        {
            [_mapView removeAnnotation:[array objectAtIndex:i]];
        }
    }
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		RouteAnnotation1* item = [[RouteAnnotation1 alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"我的位置";
		item.type = 0;
		[_mapView addAnnotation:item];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation1 alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
                
			}
			
		}
		
		item = [[RouteAnnotation1 alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = _store.storeFirmdes;
		[_mapView addAnnotation:item];
        
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
	}
}




@end
