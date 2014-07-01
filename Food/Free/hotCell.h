//
//  hotCell.h
//  Food
//
//  Created by dcw on 14-4-18.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "WebImageView.h"

@interface hotCell : UITableViewCell<UITextFieldDelegate>{
@private
    WebImageView     *_recommendImage;       //推荐头像
    UILabel         *_foodLable;            //菜名
    RTLabel         *_priceLable;         //价格
    RTLabel         *_priceLableApp;        //APP价格
    RTLabel         *_numberLable;          //编号
    RTLabel         *_amountLable;            //数量
    UITextField         *_tfcount;            //已点菜品数量
    UIButton        *_plusBut;            //加号
    UIButton        *_minusBut;           //减号
    UIButton        *_countBut;          //数量
    UIButton        *_butImage;
    
}

@property (nonatomic,retain) NSMutableDictionary *dicInfo;

@end
