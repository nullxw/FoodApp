//
//  shopListTableViewCell.m
//  Food
//
//  Created by sundaoran on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "shopListTableViewCell.h"
#import "showTheShopInMapViewController.h"


@implementation shopListTableViewCell
{
    StoreMessage   *storemessage;
    UILabel         *lblphone;
    BMKSearch           *_search;
     BMKMapView          *_mapView;
    
    NSString        *goalCity;
    NSString        *goalAddr;
    double          goallatitude;
    double          goallongitude;
    CVLocalizationSetting   *langSetting;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(id)initWithStoreDict:(StoreMessage *)store andCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        langSetting=[CVLocalizationSetting sharedInstance];
        storemessage=store;
        CGFloat  width=40;
        CGFloat  widthMax=self.frame.size.width-60;
        CGFloat  height=20;
        CGFloat  heightMax=30;
        
        UILabel *lblstoreName=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, height)];
        lblstoreName.backgroundColor=[UIColor clearColor];
        lblstoreName.text=store.storeFirmdes;
        lblstoreName.textColor=selfbackgroundColor;
        lblstoreName.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:lblstoreName];
        
        UILabel *lbllong=[[UILabel alloc]initWithFrame:CGRectMake(lblstoreName.frame.origin.x, lblstoreName.frame.origin.y+lblstoreName.frame.size.height+5, width , height)];
        lbllong.backgroundColor=[UIColor clearColor];
        lbllong.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Distance"]];
        lbllong.textColor=[UIColor blackColor];
        lbllong.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lbllong];
        
        
        CLLocationCoordinate2D  myLocal;
//        定位坐标
        myLocal.latitude=[DataProvider sharedInstance].latitude;
        myLocal.longitude=[DataProvider sharedInstance].longitude;
        
        
//        目标点坐标
         CLLocationCoordinate2D  goleXY;
        goleXY.latitude=storemessage.storelatitude;
        goleXY.longitude=storemessage.storelongitude;
        
        goallatitude=storemessage.storelatitude;
        goallongitude=storemessage.storelongitude;
    
         NSLog(@"%f",[self getCLLocationDistance:myLocal TheTowCoordinate:goleXY]);
        
        _search=[[BMKSearch alloc]init];
        _search.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,0,0)];
//        [_mapView setShowsUserLocation:YES];
        
//        根据经纬度获取地理位置编码
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        if (goleXY.latitude && goleXY.longitude) {
            pt = (CLLocationCoordinate2D){goleXY.latitude, goleXY.longitude};
        }
        BOOL flag = [_search reverseGeocode:pt];
        if (flag) {
            NSLog(@"ReverseGeocode search success.");
        }
        else{
            NSLog(@"ReverseGeocode search failed!");
        }

        
        UILabel *lblmetter=[[UILabel alloc]initWithFrame:CGRectMake(lbllong.frame.origin.x+lbllong.frame.size.width, lbllong.frame.origin.y,widthMax, height)];
        lblmetter.backgroundColor=[UIColor clearColor];
        lblmetter.text=[NSString stringWithFormat:@"%.2fKM",[self getCLLocationDistance:myLocal TheTowCoordinate:goleXY]/1000];
        lblmetter.textColor=[UIColor blackColor];
        lblmetter.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblmetter];
        
        
        UILabel *lblAddrtitle=[[UILabel alloc]initWithFrame:CGRectMake(lbllong.frame.origin.x, lbllong.frame.origin.y+lbllong.frame.size.height+10, width , height)];
        lblAddrtitle.backgroundColor=[UIColor clearColor];
        lblAddrtitle.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Address"]];
        lblAddrtitle.textColor=[UIColor blackColor];
        lblAddrtitle.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblAddrtitle];
        
        UILabel *lbladdr=[[UILabel alloc]initWithFrame:CGRectMake(lblAddrtitle.frame.origin.x+lblAddrtitle.frame.size.width, lblAddrtitle.frame.origin.y-5,widthMax, heightMax)];
        lbladdr.backgroundColor=[UIColor clearColor];
        lbladdr.text=store.storeAddr;
        lbladdr.numberOfLines=2;
        lbladdr.lineBreakMode=NSLineBreakByWordWrapping;
        lbladdr.textColor=[UIColor blackColor];
        lbladdr.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lbladdr];
        
        
        UILabel *lblphoneleft=[[UILabel alloc]initWithFrame:CGRectMake(lblstoreName.frame.origin.x, lbladdr.frame.origin.y+lbladdr.frame.size.height+5, width , height)];
        lblphoneleft.backgroundColor=[UIColor clearColor];
        lblphoneleft.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Telephone"]];
        lblphoneleft.textColor=[UIColor blackColor];
        lblphoneleft.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblphoneleft];
        
        lblphone=[[UILabel alloc]initWithFrame:CGRectMake(lblphoneleft.frame.origin.x+lblphoneleft.frame.size.width, lblphoneleft.frame.origin.y,widthMax, height)];
        lblphone.backgroundColor=[UIColor clearColor];
        lblphone.text=store.storeTele;
        lblphone.textColor=[UIColor blackColor];
        lblphone.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblphone];
        
        for (int i=0; i<2; i++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10+i*50, lblphone.frame.origin.y+lblphone.frame.size.height+5, 30, 30);
            button.tag=i;
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            switch (i) {
                case 0:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_shop.png"] forState:UIControlStateNormal];
                }
                    break;
                case 1:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_tele.png"] forState:UIControlStateNormal];
                }
                    break;
//                case 2:
//                {
//                      [button setBackgroundImage:[UIImage imageNamed:@"Public_City.png"] forState:UIControlStateNormal];   
//                }
//                    break;
                default:
                    break;
            }
            [self.contentView addSubview:button];
        }
    }
    return self;
}


//定位编码返回结果通知方法
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0)
    {
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.title = result.strAddr;
        goalCity=[NSString stringWithFormat:@"%@",result.addressComponent.city];
        goalAddr=[NSString stringWithFormat:@"%@",item.title];
	}
}



//经纬度测量两点距离
-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}


//两地间的距离百度提供
- (CLLocationDistance) getCLLocationDistance:(CLLocationCoordinate2D)coordinateA TheTowCoordinate:(CLLocationCoordinate2D )coordinateB
{
    CLLocationDistance dis;
    dis = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coordinateA), BMKMapPointForCoordinate(coordinateB)) ;
    
    return dis;
}



//0：跳转到地图界面   1：电话操作   
-(void)clickButton:(UIButton *)button
{

    switch (button.tag) {
        case 0:
        {
            showTheShopInMapViewController *show=[[showTheShopInMapViewController alloc]init];
            [DataProvider sharedInstance].goalAddr=goalAddr;
            [DataProvider sharedInstance].goalCity=goalCity;
            [DataProvider sharedInstance].goallatitude=goallatitude;
            [DataProvider sharedInstance].goallongitude=goallongitude;
            [show  setstoreMessage:storemessage];
           [self.viewController.navigationController pushViewController:show animated:YES];
        }
            break;
        case 1:
        {
            [self.superview addSubview:[DataProvider callPhoneOrtele:lblphone.text]];
        }
            break;
        case 2:
        {
             NSLog(@"3");
        }
            break;
            
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
