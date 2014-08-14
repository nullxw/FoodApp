//
//  StoreMessage.h
//  Food
//
//  Created by sundaoran on 14-4-16.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreMessage : NSObject
{
    NSString            *_storeArea;    //门店所属区域编码
    NSString            *_storeInit;    //门店字母缩写
    NSString            *_storeFirmid;  //门店编码
    NSString            *_storeTele;    //门店电话
    NSString            *_storeWbigPic; //门店显示图片地址
    NSString            *_storeAddr;    //门店地址
    NSString            *_storeFirmdes; //门店名称
    NSString            *_storeFirstAlp;//门店首字母
    NSString            *_storetableNum;      //台位数量
    NSString            *_storetablePax;   //几人台位
    NSString            *_storetabletyp;     //台位类型，（包间或者大厅）
    NSString            *_storetableName;    //台位名称
    NSString            *_storetableId;      //台位id
    NSString            *_dinnerendtime; //        晚餐自提结束时间
    NSString            *_dinnerstart;     //      晚餐自提开始时间
    
    NSString            *_lunchendtime;     //   午餐自提结束时间
    NSString            *_lunchstart;     //      午餐自提开始时间
    
    NSString            *_mustselfood;  //台位是否必须选菜
    
    
    double              _storelongitude;   //经度信息
    double              _storelatitude;    //维度信息
    
    NSMutableArray      *_storeTableArray;//台位信心
    NSMutableArray      *_storeRoomArray;//包间信息
    
    
    
}

@property(nonatomic,strong)    NSString       *storeArea;
@property(nonatomic,strong)    NSString       *storeInit;
@property(nonatomic,strong)    NSString       *storeFirmid;
@property(nonatomic,strong)    NSString       *storeTele;
@property(nonatomic,strong)    NSString       *storeWbigPic;
@property(nonatomic,strong)    NSString       *storeAddr;
@property(nonatomic,strong)    NSString       *storeFirmdes;
@property(nonatomic,strong)    NSString       *storeFirstAlp;
@property(nonatomic,strong)    NSString       *storetableNum;      //台位数量
@property(nonatomic,strong)    NSString       *storetableName;
@property(nonatomic,strong)    NSString       *storetablePax;   //几人台位
@property(nonatomic,strong)    NSString       *storetabletyp;     //台位类型，
@property(nonatomic,strong)    NSString       *storetableId;

//    获取餐次和餐次对应的时间
@property(nonatomic,strong)    NSString       *dinnerendtime; //        晚餐自提结束时间
@property(nonatomic,strong)    NSString       *dinnerstart;     //      晚餐自提开始时间

@property(nonatomic,strong)    NSString       *lunchendtime;     //   午餐自提结束时间
@property(nonatomic,strong)    NSString       *lunchstart;     //      午餐自提开始时间

@property(nonatomic,strong)    NSString       *mustselfood;

@property(nonatomic)    double       storelongitude;   //经度信息
@property(nonatomic)    double       storelatitude;




@property(nonatomic,strong)    NSMutableArray     *storeTableArray;
@property(nonatomic,strong)    NSMutableArray     *storeRoomArray;

@end
