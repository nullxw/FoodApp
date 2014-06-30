//
//  VipMessageClass.h
//  Food
//
//  Created by sundaoran on 14-4-28.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipMessageClass : NSObject
{
    NSString    *_cardId;
    NSString    *_cardNum;
    NSString    *_cardidno;
    NSString    *_cardinvoiceamt;
    NSString    *_cardname;
    NSString    *_cardstatus;
    NSString    *_cardtele;
    NSString    *_cardttlFen;
    NSString    *_cardtyp;
    NSString    *_cardzAmt;
}
@property(nonatomic,strong) NSString    *cardId;        //卡id
@property(nonatomic,strong) NSString    *cardNum;       //卡号
@property(nonatomic,strong) NSString    *cardidno;      //身份证号码
@property(nonatomic,strong) NSString    *cardinvoiceamt;//
@property(nonatomic,strong) NSString    *cardname;      //持卡人名字
@property(nonatomic,strong) NSString    *cardstatus;    //卡状态
@property(nonatomic,strong) NSString    *cardtele;      //手机
@property(nonatomic,strong) NSString    *cardttlFen;    //卡积分
@property(nonatomic,strong) NSString    *cardtyp;       //卡类型
@property(nonatomic,strong) NSString    *cardzAmt;      //卡余额

@end
