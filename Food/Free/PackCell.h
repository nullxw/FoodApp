//
//  PackCell.h
//  Food
//
//  Created by dcw on 14-4-29.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackCell : UITableViewCell{
    UILabel *name,*count;
}

@property(nonatomic,strong)NSDictionary *dicInfo;
@end
