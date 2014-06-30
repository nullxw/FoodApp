//
//  showTableCell.h
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreMessage.h"

@interface showTableCell : UITableViewCell



//设置选择门店的数据
-(void)setMessageByDict:(StoreMessage *)storeMessage;

@end
