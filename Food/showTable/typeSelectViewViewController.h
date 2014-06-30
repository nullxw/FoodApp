//
//  typeSelectViewViewController.h
//  Food
//
//  Created by sundaoran on 14-4-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "navigationBarView.h"
#import "changeCity.h"

typedef enum{
    viewSelectMenDian,  //选择门店
    
    viewSelectProvice,  //选择省份
    viewSelectCiry,     //选择城市
    viewSelectArea,     //选择区域
    viewSelectDate,     //选择日期
    viewSelectShiBie,   //选择市别
    viewSelectTime,      //选择时间
    viewSelectOnlyCity,  //只选择城市
    viewSelectBrank      //选择品牌
    
    
}viewSelectType;




@protocol typeSelectViewViewControllerDelegate <NSObject>

@optional

//代理方法
-(void)setpro:(changeCity *)pro;        //获取选择呢的省份
-(void)setCity:(changeCity *)city;      //获取选择的城市
-(void)setArea:(changeCity *)Area;      //获取选择区域
-(void)setTime:(NSString *)time;        //获取选择的时间
-(void)setShiBie:(NSString *)shiBie;    //获取选择的市别

@end

@interface typeSelectViewViewController : UIViewController<navigationBarViewDeleGete,UITableViewDataSource,UITableViewDelegate>
{
    __weak id<typeSelectViewViewControllerDelegate>_delegate;\
    
}
@property(nonatomic,weak)    __weak id<typeSelectViewViewControllerDelegate>delegate;
@property(nonatomic,strong)  void(^selectBrank)(NSMutableDictionary *brank);
-(id)initWithViewType:(viewSelectType )viewType andName:(NSString *)name;
@end
