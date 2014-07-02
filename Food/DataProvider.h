//
//  DataProvider.h
//  Food
//
//  Created by dcw on 14-3-26.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "changeCity.h"
#import "StoreMessage.h"
#import "VipMessageClass.h"

#define kOrdersFileName     @"Orders.plist"

@interface DataProvider : NSObject
{
    NSString    *_selectTime;   //选择时间
    NSString    *_selectCanCi;  //选择餐次
    NSString    *_selectBrank;
    
    NSString    *_cardType;     //会员卡类型
    NSString    *_authorPhoe;   //会员卡绑定手机验证
    NSString    *_selectOnlyCity;
    NSString    *_selecttableName;//选择的台位与_isRoom配合使用
    
    changeCity  *_selectCity; //选择的城市，省份地区对象
    
    StoreMessage   *_storeMessage;// 选择的门店信息
    
    VipMessageClass *_selectVip;//选择的要查看的会员卡
    
    
    
    NSString        *_localCity;//定位的城市
    NSString        *_localAddr;//定位地址
    double      _latitude;//定位的本地维度
    double      _longitude;//定位的本地经度
    
    NSString        *_goalCity;//目标城市
    NSString        *_goalAddr;//目标地址
    double      _goallatitude;//目标维度
    double      _goallongitude;//目标经度
    
    BOOL           _isRoom; //选择台位判断是否为包间，包间上传resvId，大厅上传台位人数Pax
    BOOL           _isFirst;//是否为第一次绑定会员卡
    
    //用于在线预点菜品提交的单利信息
    BOOL           _isReserveis;//判断是否为在线预定，或者自助点餐，真为在线预定
    NSString        *_tableId;//在线预定的台位id
    NSString       *_phoneNum;//提交信息的电话
    
    //    导航条的北京是否为1透明色
    BOOL            _isClearColor;
    
    
    //    获取餐次和餐次对应的时间
    NSString        *_dinnerendtime; //        晚餐自提结束时间
    NSString        *_dinnerstart;     //      晚餐自提开始时间
    
    NSString        *_lunchendtime;     //   午餐自提结束时间
    NSString        *_lunchstart;     //      午餐自提开始时间
    
    NSString        *_StartTime; //        市别开始时间
    NSString        *_EndTime;     //      市别结束时间
    
}
@property(nonatomic,strong)    NSString    *selectOnlyCity;  //只选择城市
@property(nonatomic,strong)    NSString    *selectTime;   //选择时间
@property(nonatomic,strong)    NSString    *selectCanCi;  //选择餐次
@property(nonatomic,strong)    NSString    *selectBrank;//选择的品牌
@property(nonatomic,strong)    NSString    *cardType;
@property(nonatomic,strong)    NSString    *authorPhoe;
@property(nonatomic,strong)    NSString    *selecttableName;
@property(nonatomic,strong)    NSString    *localCity;
@property(nonatomic,strong)    NSString    *localAddr;

@property(nonatomic,strong)    NSString    *goalCity;
@property(nonatomic,strong)    NSString    *goalAddr;

@property(nonatomic)    double              latitude;
@property(nonatomic)    double              longitude;
@property(nonatomic)    double              goallatitude;//目标维度
@property(nonatomic)    double              goallongitude;//目标经度

@property(nonatomic,strong)    changeCity  *selectCity;
@property(nonatomic,strong)    VipMessageClass *selectVip;


@property(nonatomic,strong)    StoreMessage   *storeMessage;
@property(nonatomic)           BOOL           isRoom;
@property(nonatomic)           BOOL           isFirst;

//用于在线预点菜品提交的单利信息
@property(nonatomic)           BOOL           isReserveis;
@property(nonatomic,strong)    NSString         *tableId;
@property(nonatomic,strong)    NSString       *phoneNum;

//    导航条的北京是否为1透明色
@property(nonatomic)           BOOL           isClearColor;


//    获取餐次和餐次对应的时间

@property(nonatomic,strong)    NSString       *StartTime; //        市别开始时间
@property(nonatomic,strong)    NSString       *EndTime;     //      市别结束时间


//md5加密
+(NSString *)md5:(NSString *)str;
//判断沙盒中是否存在改缓存文件
+(NSData *)imageCache:(NSString *)url;

//获取地址plist
+(NSDictionary *)getIpPlist;

//获取手机验证码
-(NSDictionary *)getPhoneAuthCode:(NSString *)phone;

//根据接口名称获取对应的数据结果
-(NSString *)getStringByfunctionName:(NSString *)functionName andDict:(NSDictionary *)dict;

//获取城市
-(NSDictionary *)getCity;

//获取菜品类别
-(NSDictionary *)getClassList:(NSMutableDictionary *)info;

//获取菜品类别，非套餐和热菜
-(NSDictionary *)getFoodList:(NSMutableDictionary *)info;

//根据门店获取所套餐
-(NSDictionary *)getPackList:(NSMutableDictionary *)info;

//根据门店获取套餐子菜品菜品
-(NSDictionary *)getPackItemList:(NSString *)str;

//根据城市获取门店
-(NSDictionary *)getStoreByArea:(NSDictionary *)dicCityCode;

//根据门店获取热门菜品
-(NSDictionary *)getHotFoodList:(NSMutableDictionary *)info;

- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg arg2:(NSString *)arg2;

//发送菜品
-(BOOL)sendFood:(NSMutableDictionary *)dicInfo;

//获取会员卡信息
-(NSDictionary *)queryCardMessage:(NSMutableDictionary *)info;

//获取用户协议
-(NSDictionary *)getUserAgreement:(NSString *)agreementId;

//提交注册信息
-(NSDictionary *)postPersonMessage:(NSMutableDictionary *)personInfo;

//获取已经绑定的会员卡信息
-(NSDictionary *)queryBindCard:(NSString *)cardPhone;

+(DataProvider *)sharedInstance;

//获取菜品从沙盒文件中
- (NSMutableArray *)orderedFood;

//保存菜品以文件的格式
- (void)saveOrders;

//获取优惠信息地区
-(NSDictionary *)getArea;

//获取优惠
-(NSDictionary *)getFavorableByAreaList:(NSString *)strArea;

//根据优惠信息列表获取详细优惠信息
-(NSDictionary *)getInfoByFavorable:(NSString *)strFavor;


//获取号码，调到电话界面
+(UIView *)callPhoneOrtele:(NSString *)phoneOrTele;

//提交订位信息
-(NSDictionary *)sendTableMessage:(NSMutableDictionary *)Info;


#pragma amrk  vipCard
-(NSDictionary *)queryVoucher:(NSMutableDictionary *)Info;

//首次绑定会员卡，提交个人信息
-(NSDictionary *)bindingVIPCard:(NSMutableDictionary *)info;

//首次绑定会员卡设置支付密码
-(NSDictionary *)updateCardPayPass:(NSMutableDictionary *)info;

//判断手机号已注册，回去该手机号下注册信息
-(NSDictionary *)getUserPersonMessage:(NSMutableDictionary *)Info;

//解除会员卡绑定
-(NSDictionary *)removeBindCard:(NSMutableDictionary *)Info;


//移除所有的会员卡，即忘记密码，让用户重新添加会员卡
-(NSDictionary *)forgetPassword:(NSMutableDictionary *)Info;

//修改支付密码
-(NSDictionary *)replacePassWord:(NSMutableDictionary *)Info;

//获取会员卡的规则
-(NSDictionary *)getCardResult;

//查询会员充值记录
-(NSDictionary *)queryChargeRecord:(NSMutableDictionary *)Info;

//查询会员消费记录
-(NSDictionary *)queryConsumeRecord:(NSMutableDictionary *)Info;


//获取我的预定
-(NSDictionary *)getOrderMenus:(NSMutableDictionary *)Info;

//取消预定
-(NSDictionary *)cancelOrder:(NSMutableDictionary *)Info;

//获取排队叫号的门店列表
-(NSDictionary *)getFirmLine:(NSMutableDictionary *)Info;

//获取排队叫号的门店台位类型
-(NSDictionary *)findPaxByFirm:(NSDictionary *)Info;

//会员卡密码验证
-(NSDictionary *)checkPassWd:(NSMutableDictionary *)Info;

//获取排队叫号结果
-(NSDictionary *)addlineNo:(NSMutableDictionary *)Info;


//获取所有排队叫号的结果
-(NSDictionary *)findMyWait:(NSMutableDictionary *)Info;

//删除叫号信息
-(NSDictionary *)cancleWait:(NSMutableDictionary *)Info;


//根据账单号获取
-(NSDictionary *)getOrderDetail:(NSMutableDictionary *)Info;


//获取广告urlimage地址
-(NSDictionary *)findPic;

//获取品牌
-(NSDictionary *)getBrands;

//获取评分栏目
-(NSDictionary *)getEvalColumn;


//提交评价信息
-(NSDictionary *)saveEvaluation:(NSDictionary *)Info;


@end
