//
//  changeCity.h
//  Food
//
//  Created by sundaoran on 14-4-8.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface changeCity : NSObject
{
    NSString *_selectprovice;
    NSString *_selectproviceId;
    NSString *_selectCity;
    NSString *_selectCityId;
    NSString *_selectArea;
    NSString *_selectAreaId;
}

@property(nonatomic,strong) NSString *selectprovice;    //选择的省份
@property(nonatomic,strong) NSString *selectproviceId;  //选择省份的id
@property(nonatomic,strong) NSString *selectCity;       //选择城市
@property(nonatomic,strong) NSString *selectCityId;     //选择城市的id
@property(nonatomic,strong) NSString *selectArea;       //选择地区
@property(nonatomic,strong) NSString *selectAreaId;     //选择地区的id

@end
