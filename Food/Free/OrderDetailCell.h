//
//  OrderDetailCell.h
//  Food
//
//  Created by dcw on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell{
    UILabel *name,*price;
    
    UILabel         *_countLable;            //已点菜品数量
    UIButton        *_plusBut;            //加号
    UIButton        *_minusBut;           //减号
    UIButton        *_countBut;          //数量
    CVLocalizationSetting *langSetting;
}
@property (nonatomic,retain) NSMutableDictionary *dicInfo;

@end
