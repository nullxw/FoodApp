//
//  showTheShopInMapViewController.h
//  Food
//
//  Created by sundaoran on 14-5-5.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"


@interface showTheShopInMapViewController : UIViewController<BMKMapViewDelegate,navigationBarViewDeleGete,BMKSearchDelegate>


//设置门店数据
-(void)setstoreMessage:(StoreMessage *)store;
@end
