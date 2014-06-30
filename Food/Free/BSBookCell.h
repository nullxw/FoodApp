//
//  BSBookCell.h
//  BookSystem-iPhone
//
//  Created by dcw on 13-12-4.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "WebImageView.h"

@class BSBookCell;
@protocol BSBookCellDelegate

- (void)detailButAction:(BSBookCell *)cell;

@end


@interface BSBookCell : UITableViewCell<UITextFieldDelegate>
{
@private
//    WebImageView     *_recommendImage;       //推荐头像
    UIButton        *_butImage;
    UILabel         *_foodLable;            //菜名
    RTLabel         *_priceLable;         //价格
    RTLabel         *_numberLable;          //编号
    RTLabel         *_amountLable;            //数量
    UITextField         *_counttf;            //已点菜品数量
    UIButton        *_plusBut;            //加号
    UIButton        *_minusBut;           //减号
    UIButton        *_countBut;          //数量
    
    UIViewController<BSBookCellDelegate> *delegate;
}


@property (nonatomic,retain) NSMutableDictionary *dicInfo;
@property (nonatomic,assign) UIViewController<BSBookCellDelegate> *delegate;
@property (nonatomic,strong) WebImageView *recommendImage;


- (void)changeFood:(NSMutableDictionary *)foodInfo byCount:(NSString *)count;

@end
