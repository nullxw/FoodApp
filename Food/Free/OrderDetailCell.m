//
//  OrderDetailCell.m
//  Food
//
//  Created by dcw on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
        langSetting = [CVLocalizationSetting sharedInstance];
    }
    return self;
}

//初始化控件
-(void)_init{
    name = [[UILabel alloc] initWithFrame:CGRectZero];
    name.frame = CGRectMake(5, 5, 220, 25);
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:13.0];
    name.numberOfLines = 3;
    [self.contentView addSubview:name];
    
    price = [[UILabel alloc] initWithFrame:CGRectZero];
    price.frame = CGRectMake(5, 30, 70, 20);
    price.backgroundColor = [UIColor clearColor];
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont systemFontOfSize:11.0];
    [self.contentView addSubview:price];
    
    _plusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _plusBut.backgroundColor = [UIColor clearColor];
    [_plusBut setBackgroundImage:[UIImage imageNamed:@"Order_check_plus.png"] forState:UIControlStateNormal];
    [_plusBut addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    _plusBut.frame = CGRectMake(ScreenWidth-32-18, 15, 30, 30);
    [self.contentView addSubview:_plusBut];
    
    _countBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _countBut.backgroundColor = [UIColor clearColor];
    [_countBut setBackgroundImage:[UIImage imageNamed:@"Order_check_Num.png.png"] forState:UIControlStateNormal];
    _countBut.frame = CGRectMake(ScreenWidth-32*2-18, 15, 30, 30);
    [self.contentView addSubview:_countBut];
    
    _countLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _countLable.frame = CGRectMake(0, 0, 30, 30);
    _countLable.textColor = [UIColor redColor];
    _countLable.backgroundColor = [UIColor clearColor];
    _countLable.font = [UIFont systemFontOfSize:11.0];
    _countLable.textAlignment = NSTextAlignmentCenter;
    [_countBut addSubview:_countLable];
    
    _minusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _minusBut.backgroundColor = [UIColor clearColor];
    [_minusBut setBackgroundImage:[UIImage imageNamed:@"Order_check_minus.png"] forState:UIControlStateNormal];
    [_minusBut addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    _minusBut.frame = CGRectMake(ScreenWidth-32*3-18, 15, 30, 30);
    [self.contentView addSubview:_minusBut];
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
        _countLable.text = [info objectForKey:@"total"];
        NSString *strPrice = [NSString stringWithFormat:@"%@/%@",[info objectForKey:@"price"],[langSetting localizedString:@"tao"]];
        price.text = strPrice;
    }else{
        name.text = [info objectForKey:@"pdes"];
        _countLable.text = [info objectForKey:@"total"];
        NSString *strPrice = [NSString stringWithFormat:@"%@/%@",[info objectForKey:@"price"],[info objectForKey:@"unit"]];
        price.text = strPrice;
    }
    
}

//加号事件
-(void)plusClick{
    [self addFood:self.dicInfo byCount:@"1"];
}
//减号事件
-(void)minusClick{
    [self minusFood:self.dicInfo];
}
//添加
- (void)addFood:(NSMutableDictionary *)foodInfo byCount:(NSString *)count{
    
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
    
    BOOL bFinded = NO;
    for (NSDictionary *food in ary){
        if ([[food objectForKey:@"id"] isEqualToString:[foodInfo objectForKey:@"id"]] |[[food objectForKey:@"pubitem"] isEqualToString:[foodInfo objectForKey:@"pubitem"]]){
            bFinded = YES;
            int total = [[food objectForKey:@"total"] intValue];
            total += [count floatValue];
            
            if (total>0){
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:food];
                [mut setObject:[NSString stringWithFormat:@"%d",total] forKey:@"total"];
                [ary replaceObjectAtIndex:[ary indexOfObject:food] withObject:mut];
            }else
                [ary removeObject:food];
            
            [dp saveOrders];
            break;
        }
    }
    
    if (!bFinded && [count floatValue]>0){
        [foodInfo setValue:count forKey:@"total"];
        [ary addObject:foodInfo];
        [dp saveOrders];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderDetailTableNotification" object:nil];
    
}
//减少
-(void)minusFood:(NSMutableDictionary *)foodInfo{
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
    BOOL bFinded = NO;
    for (NSDictionary *food in ary){
        if ([[food objectForKey:@"id"] isEqualToString:[foodInfo objectForKey:@"id"]] |[[food objectForKey:@"pubitem"] isEqualToString:[foodInfo objectForKey:@"pubitem"]]){
            bFinded = YES;
            int total = [[food objectForKey:@"total"] intValue];
            if (total>1){
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:food];
                [mut setObject:[NSString stringWithFormat:@"%d",total-1] forKey:@"total"];
                [ary replaceObjectAtIndex:[ary indexOfObject:food] withObject:mut];
            }else
                [ary removeObject:food];
            
            [dp saveOrders];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOrderDetailTableNotification" object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
