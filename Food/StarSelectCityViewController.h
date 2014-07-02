//
//  FreeClickViewController.h
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "typeSelectViewViewController.h"

@interface StarSelectCityViewController : UIViewController<navigationBarViewDeleGete,typeSelectViewViewControllerDelegate>{
    UITableView         *_tableView;
    
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    UILabel             *_lblchangeCity;
    
    NSMutableArray      *_dataCity,*_dataCityCode;
    
    NSString *strCity,*strMenDian,*strYuDingRiQi,*strShiBie,*strShijian,*strCityCode;
    
    NSDictionary *dicStore;        //门店
    
    CVLocalizationSetting *langSetting;
}

@end
