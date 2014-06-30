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

@interface FreeClickViewController : UIViewController<navigationBarViewDeleGete,UIPickerViewDataSource,UIPickerViewDelegate,typeSelectViewViewControllerDelegate>{
    UITableView         *_tableView;
    
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    UILabel             *_lblchangeCity;
    UILabel             *_lblchangeTime;
    UILabel             *_lblchangeSession;
    
    UILabel             *lblSelection;
    UIView              *vPicker;
    
    NSMutableArray      *_dataCity,*_dataCityCode;
    NSMutableArray      *_dataSession;
    NSMutableArray      *_dataYear;
    NSMutableArray      *_dataMoon;
    NSMutableArray      *_dataDay;
    NSMutableArray      *aryWuDate,*aryYeDate;
    
    
    NSInteger           selectYear;
    NSInteger           selectMoon;
    NSInteger           selectDay;
    
    NSInteger           flag;
    
    NSString *strCity,*strMenDian,*strYuDingRiQi,*strShiBie,*strShijian,*strCityCode;
    NSString *yy,*MM,*dd;
    
    NSString            *NowMoon;  //当前月份
    NSString            *NowDay;    //当前日
    NSDictionary *dicStore;        //门店
    
    CVLocalizationSetting *langSetting;
}

@end
