//
//  shopListTableViewCell.h
//  Food
//
//  Created by sundaoran on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreMessage.h"
#import "BMapKit.h"



@interface shopListTableViewCell : UITableViewCell<BMKMapViewDelegate,BMKSearchDelegate>


//设置选择门店的基本数据
-(id)initWithStoreDict:(StoreMessage *)store andCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
