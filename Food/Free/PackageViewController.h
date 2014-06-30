//
//  PackageViewController.h
//  Food
//
//  Created by dcw on 14-4-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"

@interface PackageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,navigationBarViewDeleGete>{
    WebImageView *imgView;
    UITableView *tvPackItem;
    NSArray *aryPackItem;
    CVLocalizationSetting *langSetting;
}
@property (nonatomic,strong) NSDictionary  *dicInfo;

- (void)setDicInfo:(NSDictionary *)dic;
-(void)setDictInfoByLookorder:(NSDictionary *)dic;

@end
