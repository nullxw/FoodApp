//
//  FavorableViewController.h
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavorableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,navigationBarViewDeleGete>{
    UITableView *tvFavorable;
    NSArray     *aryResult;
    NSMutableArray *aryCell;
}

@property (nonatomic,strong) NSString *firmid;
@end
