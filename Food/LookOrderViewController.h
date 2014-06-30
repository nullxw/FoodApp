//
//  LookOrderViewController.h
//  Food
//
//  Created by sundaoran on 14-6-5.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookOrderViewController : UIViewController<navigationBarViewDeleGete,UITableViewDataSource,UITableViewDelegate>


-(id)initWithInfo:(NSMutableArray *)InfoArray;

@end
