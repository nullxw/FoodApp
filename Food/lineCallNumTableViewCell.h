//
//  lineCallNumTableViewCell.h
//  Food
//
//  Created by sundaoran on 14-5-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectTableTypeViewController.h"

@interface lineCallNumTableViewCell : UITableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andStoreMessage:(NSDictionary   *)dict;

-(void)setInfoDict:(NSDictionary *)dict;
@end
