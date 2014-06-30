//
//  OrderViewController.h
//  Food
//
//  Created by dcw on 14-4-16.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController<navigationBarViewDeleGete,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *tvOrder;
    NSMutableArray *aryOrder;
    float allPrice;
    UILabel *lblAddition,*lblCount,*lblSum,*lblAdd;
    CVLocalizationSetting *langSetting;
}
@property (nonatomic,strong) NSMutableDictionary *dicInfo;
@end
