//
//  orderCell.m
//  Food
//
//  Created by dcw on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "orderCell.h"

@implementation orderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    return self;
}
//初始化控件
-(void)_init{
    name = [[UILabel alloc] initWithFrame:CGRectZero];
    name.frame = CGRectMake(0, 5, 170, 30);
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:13.0];
    name.numberOfLines = 3;
    [self.contentView addSubview:name];
    
    count = [[UILabel alloc] initWithFrame:CGRectZero];
    count.frame = CGRectMake(170, 5, 60, 30);
    count.backgroundColor = [UIColor clearColor];
    count.textAlignment = NSTextAlignmentCenter;
    count.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:count];
    
    price = [[UILabel alloc] initWithFrame:CGRectZero];
    price.frame = CGRectMake(220, 5, 70, 30);
    price.backgroundColor = [UIColor clearColor];
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:price];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDicInfo:(NSDictionary *)dic{
    
    if (_dicInfo!=dic){
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        [self showInfo:dic];
    }
}

//显示信息
- (void)showInfo:(NSDictionary *)info{
    if ([[info objectForKey:@"grpStr"] isEqualToString:@"套餐"]) {
        name.text = [info objectForKey:@"des"];
        count.text = [info objectForKey:@"total"];
        price.text = [info objectForKey:@"price"];
    }else{
        name.text = [info objectForKey:@"pdes"];
        count.text = [info objectForKey:@"total"];
        price.text = [info objectForKey:@"price"];
    }
    
}

@end
