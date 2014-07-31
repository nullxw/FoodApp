//
//  showTheShopInMapViewController.m
//  Food
//
//  Created by sundaoran on 14-5-5.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "showTheShopInMapViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

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

@interface showTheShopInMapViewController ()
{
    BMKMapView          *_mapView;
    BMKSearch           *_search;
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    NSMutableArray      *_buttonArray;
    
    UIView              *_mapTypeView;//选择地图显示类型的view
    BOOL                isShowChangeType;
    
    StoreMessage        *_store;
    
    CVLocalizationSetting  *langSetting;

}

@end

@implementation showTheShopInMapViewController

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



-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil; // 不用时，置nil
}

-(void)setstoreMessage:(StoreMessage *)store
{
    _store=store;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting  =[CVLocalizationSetting sharedInstance];
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
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Map"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width,_backGround.frame.size.height-VIEWHRIGHT-44)];
    [_mapView setShowMapScaleBar:YES];
    [_mapView setShowsUserLocation:NO];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
     [_mapView setShowsUserLocation:YES];
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
        [button setTitle:[NSString stringWithFormat:@"%@",[langSetting localizedString:@"Planar map"]] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:[NSString stringWithFormat:@"%@",[langSetting localizedString:@"Scenery map"]] forState:UIControlStateNormal];
        }
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        button.tag=2000+i;
        [button setBackgroundColor:selfbackgroundColor];
        [button addTarget:self action:@selector(mapTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mapTypeView addSubview:button];
    }
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rufushlocal) name:@"refushlocal" object:nil];
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


//1000：公交线路规划   1001：自驾车线路规划   1002：定位   1003：步行线路规划
-(void)buttonClick:(UIButton *)button
{

    DataProvider *dp=[DataProvider sharedInstance];
    switch (button.tag)
    {
//            公交新路规划
        case 1000:
        {
            if(isShowChangeType)
            {
//                每次点击，如果改变地图类型的视图存在则从父视图移除
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
            
           BOOL flag = [_search transitSearch:dp.localCity startNode:start endNode:end];
            if (flag) {
                NSLog(@"search success.");
            }
            else{
                NSLog(@"search failed!");
            }

        }break;
//            自驾车线路规划
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
//            定位
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
            
//            步行线路规划
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
            
//            改变地图类型
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

//添加地图标注
- (void) viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = _store.storelatitude ;
    coor.longitude =_store.storelongitude ;
    annotation.coordinate = coor;
    annotation.title =_store.storeFirmdes;
    [_mapView addAnnotation:annotation];
}

// Override
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


#pragma mark  -----线路规划
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
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

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
  
        ((BMKPinAnnotationView*)annotation).pinColor = BMKPinAnnotationColorPurple;
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];

	}
	return nil;
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
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    if (error == BMKErrorOk) {
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"我的位置";
		item.type = 0;
		[_mapView addAnnotation:item]; // 添加起点标注
        
		item = [[RouteAnnotation alloc]init];
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
			
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item]; // 上车标注
			
			route = [plan.routes objectAtIndex:i+1];
			item = [[RouteAnnotation alloc]init];
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
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
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
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];

                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = _store.storeFirmdes;
            [_mapView addAnnotation:item];

            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
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
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = [langSetting localizedString:@"My location"];
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
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];

			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
