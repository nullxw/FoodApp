//
//  orderCell.h
//  Food
//
//  Created by dcw on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderCell : UITableViewCell{
    UILabel *name,*price,*count;
}
@property (nonatomic,retain) NSMutableDictionary *dicInfo;
@end
