//
//  DataProvider.m
//  Food
//
//  Created by dcw on 14-3-26.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "DataProvider.h"
#import "BSWebServiceAgent.h"
#import "AFHTTPRequestOperation.h"
#import <CommonCrypto/CommonHMAC.h>

//static NSString *strNetwork = @"network connection timeout";
static NSString *strNetwork = @"网络连接失败，请检查网络";
static NSMutableArray *aryOrders = nil;
@implementation DataProvider

@synthesize selectCanCi=_selectCanCi,selectOnlyCity=_selectOnlyCity,selectTime=_selectTime,selectBrank=_selectBrank;
@synthesize selectCity=_selectCity;
@synthesize storeMessage=_storeMessage;
@synthesize isRoom=_isRoom;
@synthesize cardType=_cardType;
@synthesize authorPhoe=_authorPhoe;
@synthesize isFirst=_isFirst;
@synthesize selectVip=_selectVip;
@synthesize selecttableName=_selecttableName;

@synthesize latitude=_latitude,longitude=_longitude;

@synthesize localAddr=_localAddr,goalAddr=_goalAddr,localCity=_localCity,goalCity=_goalCity;

@synthesize goallatitude=_goallatitude,goallongitude=_goallongitude;
@synthesize isReserveis =_isReserveis;
@synthesize tableId=_tableId;
@synthesize phoneNum=_phoneNum;

@synthesize isClearColor=_isClearColor;
@synthesize isShop=_isShop;


//选择市别后判断开始结束时间
@synthesize StartTime=_StartTime;
@synthesize EndTime=_EndTime;

static  DataProvider *_dataProvide = nil;
+(DataProvider *)sharedInstance
{
    if(!_dataProvide)
    {
        _dataProvide=[[DataProvider alloc]init];
        aryOrders = [[NSMutableArray alloc] init];
        NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        NSString *path = [docPath stringByAppendingPathComponent:kOrdersFileName];
        NSDictionary *dicOrders = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *ary = [dicOrders objectForKey:@"orders"];
        
        [aryOrders addObjectsFromArray:ary];
    }
    return _dataProvide;
}

//md5加密
+(NSString *)md5:(NSString *)str {
    if(str)
    {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    }
    else
    {
        return nil;
    }
}
+(NSData *)imageCache:(NSString *)url //判断缓存中是否存在文件
{
    
    NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"] ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[localPath stringByAppendingString:[NSString stringWithFormat:@"/%@",[DataProvider md5:url]]];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        NSData *data=[fileManager contentsAtPath:filePath];
        return data;
    }
    else
    {
        return nil;
    }
}

//获取地址plist
+(NSDictionary *)getIpPlist
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"Ip" ofType:@"plist"];
    NSDictionary *dict=[[NSDictionary alloc]initWithContentsOfFile:path];
    return dict;
}


//计算选择的时间是否超过当前时间 没超过返回YES
+(BOOL)compareNowTime:(NSString *)timeStr
{
    NSString *GLOBAL_TIMEFORMAT = @"yyyy-MM-dd HH:mm";
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:GLOBAL_TIMEFORMAT];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:timeStr];
    
    NSDate *firstDate = [NSDate dateWithTimeInterval:-3600*8 sinceDate:bdate];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeInterval _fitstDate = [firstDate timeIntervalSince1970]*1;
    NSTimeInterval _secondDate = [datenow timeIntervalSince1970]*1;
    
    if (_fitstDate - _secondDate > 0) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg arg2:(NSString *)arg2{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict = [agent GetData:api arg:arg arg2:arg2];
    return dict;
}

//保存已点菜品
- (void)saveOrders{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:kOrdersFileName];
    NSArray *aryOrd = [NSArray arrayWithArray:aryOrders];
    if ([aryOrd count]>0){
        NSMutableArray *ary = [NSMutableArray array];
        for (NSDictionary *dic in aryOrd){
            if ([[dic objectForKey:@"total"] intValue]!=0)
                [ary addObject:dic];
        }
        if ([ary count]>0){
            NSDictionary *dict = [NSDictionary dictionaryWithObject:ary forKey:@"orders"];
            [dict writeToFile:path atomically:NO];
        }
    }
    else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:nil];
    }
}

//获取已点菜品
- (NSMutableArray *)orderedFood{
    return aryOrders;
}

//获取手机验证码
-(NSDictionary *)getPhoneAuthCode:(NSString *)phone{
    NSString *strParam = [NSString stringWithFormat:@"?generateRandom=%@",phone];
    NSDictionary *dict = [self bsService:@"generateRandom" arg:strParam arg2:@"CTF/webService/CRMWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"generateRandom" andDict:dict];
        if (![result isEqualToString:@""]) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",result,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",result,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

-(NSString *)getStringByfunctionName:(NSString *)functionName andDict:(NSDictionary *)dict
{
    NSString *result = [[[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:[NSString stringWithFormat:@"ns1:%@Response",functionName]] objectForKey:@"return"] objectForKey:@"text"];
    return result;
}

//获取城市
-(NSDictionary *)getCity{
    NSDictionary *dict = [self bsService:@"getCity" arg:nil arg2:@"CTF/webService/BOHWebService/"];
    //getCity
    if (dict) {
        NSArray *aryResult =[self getStringByfunctionName1:@"getCity" andDict:dict];
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"获取城市信息失败",@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    
    return nil;
}
//获取城市返回数据解析
-(NSArray *)getStringByfunctionName1:(NSString *)functionName andDict:(NSDictionary *)dict
{
    NSString *result = [[[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:[NSString stringWithFormat:@"ns1:%@Response",functionName]] objectForKey:@"return"] objectForKey:@"text"];
    NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
    NSMutableArray *ary = [[[dic objectForKey:@"listTele"] objectForKey:@"listCity"] objectForKey:@"com.choice.webService.domain.City"];
    return ary;
}


//根据城市获取门店
-(NSDictionary *)getStoreByArea:(NSDictionary *)dicCityCode{
    //F/webService/APPWebService/getStoreByArea?getStoreByArea=124
    
    //key  area  area   //城市编码
    //key  dat   dat    //日期
    //key  sft   sft    //餐次
    
    //    晚餐2  午餐1
    
    //    dinnerend      晚餐结束时间
    //    dinnerendtime  晚餐自提结束时间
    //    dinnerstart    晚餐自提开始时间
    
    //    lunchend       午餐结束时间
    //    lunchendtime   午餐自提结束时间
    //    lunchstart      午餐自提开始时间
    NSString *strParam;
    if(self.isShop)
    {
        if([dicCityCode objectForKey:@"type"])
        {
#pragma worring     ---area
            //           strParam = [NSString stringWithFormat:@"?area=%@&type=1",[dicCityCode objectForKey:@"area"]];
            //            北京
            strParam = [NSString stringWithFormat:@"?area=%@&type=1",[dicCityCode objectForKey:@"area"]];
        }
        else
        {
            strParam = [NSString stringWithFormat:@"?area=%@&type=0",[dicCityCode objectForKey:@"area"]];
        }
    }
    else
    {
        strParam = [NSString stringWithFormat:@"?area=%@&dat=%@&sft=%@&type=0&brandcode=%@",[dicCityCode objectForKey:@"area"],[dicCityCode objectForKey:@"dat"],[dicCityCode objectForKey:@"sft"],[dicCityCode objectForKey:@"brandcode"]];
    }
    
    NSDictionary *dict = [self bsService:@"getStoreByArea" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"getStoreByArea" andDict:dict];
        //截取字符串判断门店的个数
        NSArray *ary = [result componentsSeparatedByString:@"com.choice.webService.domain.Firm"];
        
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        //        判断返回的数据为空
        NSMutableArray *aryResult = [[NSMutableArray alloc] init];
        NSString *key=[[[[dic objectForKey:@"listTele"] objectForKey:@"listFirm"]allKeys] firstObject];
        if([[[[[dic objectForKey:@"listTele"]objectForKey:@"listFirm"]allKeys]firstObject]isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        //如果门店的个数返回的是一个的时候，得到的是字典不是数组，此处做个判断，判断如果是一个门店的时候转换一下
        else if([result isEqualToString:@"listTele"]||[key isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"暂无门店数据",@"Message", nil];
        }

        else if ([ary count] <= 2) {
            NSDictionary *dic2 = [[[dic objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
            if(dic2!=nil)
            {
                [aryResult addObject:dic2];
            }
        }else{
            aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
        }
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//根据门店获取类别
-(NSDictionary *)getClassList:(NSMutableDictionary *)info{
    NSString *city,*Store,*targetDate,*shiBie,*Date,*firmId;
    city = [info objectForKey:@"city"];
    Store = [info objectForKey:@"Store"];
    targetDate = [info objectForKey:@"targetDate"];
    shiBie = [info objectForKey:@"shiBie"];
    Date = [info objectForKey:@"Date"];
    firmId = [info objectForKey:@"firmId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@",firmId];
    
    NSDictionary *dict = [self bsService:@"getTeleProjectType" arg:strParam arg2:@"CTF/webService/BOHWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"getTeleProjectType" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        //        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProjectType"] objectForKey:@"com.choice.webService.domain.ProjectType"];
        
        NSArray *ary = [result componentsSeparatedByString:@"com.choice.webService.domain.ProjectType"];
        
        //        判断返回的数据为空
        NSMutableArray *aryResult = [[NSMutableArray alloc] init];
        if([[[[[dic objectForKey:@"listTele"]objectForKey:@"listProjectType"]allKeys]firstObject]isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        //如果个数返回的是一个的时候，得到的是字典不是数组，此处做个判断，判断如果是一个门店的时候转换一下
        if ([ary count] <= 2) {
            NSDictionary *dic2 = [[[dic objectForKey:@"listTele"] objectForKey:@"listProjectType"] objectForKey:@"com.choice.webService.domain.ProjectType"];
            if(dic2!=nil)
            {
                [aryResult addObject:dic2];
            }
        }else{
            aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProjectType"] objectForKey:@"com.choice.webService.domain.ProjectType"];
        }
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}


//根据门店获取所有菜品
-(NSDictionary *)getFoodList:(NSMutableDictionary *)info{
    NSString *city,*Store,*targetDate,*shiBie,*Date,*firmId;
    city = [info objectForKey:@"city"];
    Store = [info objectForKey:@"Store"];
    targetDate = [info objectForKey:@"targetDate"];
    shiBie = [info objectForKey:@"shiBie"];
    Date = [info objectForKey:@"Date"];
    firmId = [info objectForKey:@"firmId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@",firmId];
    
    NSDictionary *dict = [self bsService:@"getFdItemSale" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"getFdItemSale" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        //        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
        
        NSArray *ary = [result componentsSeparatedByString:@"com.choice.webService.domain.Project"];
        
        //        判断返回的数据为空
        NSMutableArray *aryResult = [[NSMutableArray alloc] init];
        if([[[[[dic objectForKey:@"listTele"]objectForKey:@"listProject"]allKeys]firstObject]isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        //如果个数返回的是一个的时候，得到的是字典不是数组，此处做个判断，判断如果是一个门店的时候转换一下
        if ([ary count] <= 2) {
            NSDictionary *dic2 = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
            if(dic2!=nil)
            {
                [aryResult addObject:dic2];
            }
        }else{
            aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
        }
        
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}


//根据门店获取所套餐
-(NSDictionary *)getPackList:(NSMutableDictionary *)info{
    NSString *city,*Store,*targetDate,*shiBie,*Date,*firmId;
    city = [info objectForKey:@"city"];
    Store = [info objectForKey:@"Store"];
    targetDate = [info objectForKey:@"targetDate"];
    shiBie = [info objectForKey:@"shiBie"];
    Date = [info objectForKey:@"Date"];
    firmId = [info objectForKey:@"firmId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@",firmId];
    
    NSDictionary *dict = [self bsService:@"getItemPgPack" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"getItemPgPack" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listItemPrgPackage"] objectForKey:@"com.choice.webService.domain.ItemPrgPackage"];
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//根据门店获取热门菜品
-(NSDictionary *)getHotFoodList:(NSMutableDictionary *)info{
    NSString *city,*Store,*targetDate,*shiBie,*Date,*firmId;
    city = [info objectForKey:@"city"];
    Store = [info objectForKey:@"Store"];
    targetDate = [info objectForKey:@"targetDate"];
    shiBie = [info objectForKey:@"shiBie"];
    Date = [info objectForKey:@"Date"];
    firmId = [info objectForKey:@"firmId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@",firmId];
    
    NSDictionary *dict = [self bsService:@"findHotItem" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"findHotItem" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        //        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
        
        NSArray *ary = [result componentsSeparatedByString:@"com.choice.webService.domain.Project"];
        
        //        判断返回的数据为空
        NSMutableArray *aryResult = [[NSMutableArray alloc] init];
        if([[[[[dic objectForKey:@"listTele"]objectForKey:@"listProject"]allKeys]firstObject]isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        //如果个数返回的是一个的时候，得到的是字典不是数组，此处做个判断，判断如果是一个门店的时候转换一下
        else if ([ary count] <= 2) {
            NSDictionary *dic2 = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
            if(dic2!=nil)
            {
                [aryResult addObject:dic2];
            }
        }else{
            aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
        }
        
        
        if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}


//根据门店获取套餐子菜品菜品
-(NSDictionary *)getPackItemList:(NSString *)str{
    //192.168.0.177:8081/CTF/webService/APPWebService/getItemPgPackDtl?packageId=9963ad65d9434f0b80da7291ce1f4a02
    
    NSString *strParam = [NSString stringWithFormat:@"?packageId=%@",str];
    
    NSDictionary *dict = [self bsService:@"getItemPgPackDtl" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"getItemPgPackDtl" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listItemPrgpackAgedtl"] objectForKey:@"com.choice.webService.domain.ItemPrgpackAgedtl"];
        NSString *key=[[[[dic objectForKey:@"listTele"] objectForKey:@"listItemPrgpackAgedtl"]allKeys] lastObject];
        if ([result isEqualToString:@"listTele"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"暂无数套餐数据",@"Message", nil];
        }
        else if ([key isEqualToString:@"text"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"暂无数套餐数据",@"Message", nil];
        }
        else if ([result isEqualToString:@"false"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"当前网络不稳定，请重试",@"Message", nil];
        }
        else if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//提交注册信息
-(NSDictionary *)postPersonMessage:(NSMutableDictionary *)personInfo
{
    
    
    NSString *telePhone,*userName,*userSex,*passWord,*userAddr;
    telePhone=[personInfo objectForKey:@"telePhone"];
    userName=[personInfo objectForKey:@"userName"];
    userSex=[personInfo objectForKey:@"userSex"];
    //    0:男士  1：女士
    passWord=[personInfo objectForKey:@"passWord"];
    userAddr=[personInfo objectForKey:@"userAddr"];
    
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@&name=%@&sex=%@&password=%@&addr=%@",telePhone,userName,userSex,passWord,userAddr];
    
    NSDictionary *dict = [self bsService:@"saveCard" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict)
    {
        //解析
        NSString *result =[self getStringByfunctionName:@"saveCard" andDict:dict];
        NSDictionary *dicResult ;
        if([result isEqualToString:@"false"])
        {
            dicResult =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"当前网络不稳定，请重试",@"Message", nil ];
            return  dicResult;
        }
        else if([result isEqualToString:@"true"])
        {
            dicResult =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"成功",@"Message", nil ];
            return  dicResult;
        }
        else if([result isEqualToString:@"mobtel"])
        {
            dicResult =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"该手机号已被注册",@"Message", nil ];
            return  dicResult;
        }
        else
        {
            //            返回用户唯一标示
            dicResult =[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",result,@"Message", nil ];
            return  dicResult;
        }
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}

//发送菜品
-(BOOL)sendFood:(NSMutableDictionary *)dicInfo{
    
    //192.168.0.177:8081/CTF/webService/APPWebService/saveOrdersFdItemDtl?dat=2014-04-28&datMins=14:00&firmId=31&remark=bbbbbb&fdItemDtl=[{id:'123',count:3,type:1},{id:'123',count:3,type:1}]&mobtel=18254109366&name=邓
    
    //    [{id:'123',count:3,type:1},{id:'123',count:3,type:1}]
    NSString *name,*phone,*dat,*datMins,*firmId,*remark,*type,*foodId;
    NSMutableString *fdItemDtl = [[NSMutableString alloc] init];
    
    name = [dicInfo objectForKey:@"name"];
    phone = [dicInfo objectForKey:@"phone"];
    dat = [dicInfo objectForKey:@"targetDate"];
    datMins = [dicInfo objectForKey:@"Date"];
    firmId = [[dicInfo objectForKey:@"Store"] objectForKey:@"firmid"];
    remark = [dicInfo objectForKey:@"remark"];//特殊备注
    NSString  *orderId=[dicInfo objectForKey:@"orderId"];//在线预点预订台位id
    
    [fdItemDtl appendString:@"["];
    int i = 0;
    for (NSDictionary *dic in self.orderedFood) {
        i++;
        [fdItemDtl appendString:@"{"];
        
        if ([[dic objectForKey:@"grpStr"] isEqualToString:@"套餐"]) {
            foodId = [NSString stringWithFormat:@"id:'%@',",[dic objectForKey:@"id"]];
            type = [NSString stringWithFormat:@"type:%@",@"0"];
        }else{
            foodId = [NSString stringWithFormat:@"id:'%@',",[dic objectForKey:@"pubitem"]];
            type = [NSString stringWithFormat:@"type:%@",@"1"];
        }
        NSString *count = [NSString stringWithFormat:@"count:%@,",[dic objectForKey:@"total"]];
        [fdItemDtl appendString:foodId];
        [fdItemDtl appendString:count];
        [fdItemDtl appendString:type];
        
        if (i >= [self.orderedFood count]) {
            [fdItemDtl appendString:@"}"];
        }else{
            [fdItemDtl appendString:@"},"];
        }
        
    }
    [fdItemDtl appendString:@"]"];
    
    NSString *strParam;
    if(![remark isEqualToString:@""])
    {
        if([orderId isEqualToString:@""])
        {
            strParam= [NSString stringWithFormat:@"?dat=%@&datMins=%@&firmId=%@&remark=%@&fdItemDtl=%@&mobtel=%@&name=%@",dat,datMins,firmId,remark,fdItemDtl,phone,name];
        }
        else
        {
            strParam= [NSString stringWithFormat:@"?dat=%@&datMins=%@&firmId=%@&remark=%@&fdItemDtl=%@&mobtel=%@&name=%@&orderId=%@",dat,datMins,firmId,remark,fdItemDtl,phone,name,orderId];
        }
        
    }
    else
    {
        if([orderId isEqualToString:@""])
        {
            strParam= [NSString stringWithFormat:@"?dat=%@&datMins=%@&firmId=%@&fdItemDtl=%@&mobtel=%@&name=%@",dat,datMins,firmId,fdItemDtl,phone,name];
        }
        else
        {
            strParam= [NSString stringWithFormat:@"?dat=%@&datMins=%@&firmId=%@&fdItemDtl=%@&mobtel=%@&name=%@&orderId=%@",dat,datMins,firmId,fdItemDtl,phone,name,orderId];
        }
        
    }
    
    NSDictionary *dict = [self bsService:@"saveOrdersFdItemDtl" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"saveOrdersFdItemDtl" andDict:dict];
        if ([result isEqualToString:@"true"]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

//获取会员卡信息
-(NSDictionary *)queryCardMessage:(NSMutableDictionary *)info
{
    NSString *cardNum = [info objectForKey:@"cardNum"];
    NSString *strParam = [NSString stringWithFormat:@"?cardNo=%@",cardNum];
    
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSDictionary *dict = [self bsService:@"queryCardMessage" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryCardMessage" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if([[[[[dictValue objectForKey:@"listTele" ]objectForKey:@"listCard"]allKeys]firstObject] isEqualToString:@"text"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"卡号为%@的会员卡不存在",cardNum],@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Firm"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listCard"] objectForKey:@"com.choice.webService.domain.Card"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listCard"] objectForKey:@"com.choice.webService.domain.Card"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
}
//获取用户协议
-(NSDictionary *)getUserAgreement:(NSString *)agreementId
{
    NSString *strParam = [NSString stringWithFormat:@"?moduleId=%@",agreementId];
    
    NSDictionary *dict = [self bsService:@"getUserAgreement" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict)
    {
        //解析
        NSString *result =[self getStringByfunctionName:@"getUserAgreement" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listWebMsg"] objectForKey:@"com.choice.webService.domain.WebMsg"];
        
        if ([aryResult count] > 0)
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}

//添加会员卡信息
//-(NSDictionary *)bindingVIPCard:(NSDictionary *)infoDict
//{
//    NSString *cardPhone=@"";//手机号码
//    NSString *cardNum=@"";//卡号
//    NSString *cardTyp=@"";//卡类型
//    NSString *credenTyp=@"";//证件类型
//    NSString *credcredenNo=@"";//证件号码
//    NSString *credphone=@"";//持卡人手机号码
//    NSString *credpayPass=@"";//支付密码
//
//    NSString *strParam = [NSString stringWithFormat:@"?moduleId=%@",agreementId];
//
//    NSDictionary *dict = [self bsService:@"getUserAgreement" arg:strParam arg2:@"CTF/webService/APPWebService/"];
//
//    if (dict)
//    {
//        //解析
//        NSString *result =[self getStringByfunctionName:@"getUserAgreement" andDict:dict];
//        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
//
//        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listWebMsg"] objectForKey:@"com.choice.webService.domain.WebMsg"];
//
//        if ([aryResult count] > 0)
//        {
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
//        }
//        else
//            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message", nil];
//    }
//    else
//    {
//        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
//    }
//    return nil;
//
//}


//首次绑定会员卡，提交个人信息
-(NSDictionary *)bindingVIPCard:(NSMutableDictionary *)info
{
    //    判断是否为第一次绑定
    NSString *strParam;
    if([[info objectForKey:@"isFirst"]boolValue])
    {
        //        第一次绑定与设置密码同步提交，改为设置密码接口
        //        NSString *name=[info objectForKey:@"name"];//姓名
        //        NSString *cardNum=[info objectForKey:@"cardNo"];//卡号
        //        NSString *mobtel=[info objectForKey:@"tele"];//手机号码
        //        strParam = [NSString stringWithFormat:@"?name=%@&cardNo=%@&mobtel=%@",name,cardNum,mobtel];
    }
    else
    {
        //        第二次绑定
        NSString *cardNum=[info objectForKey:@"cardNo"];//卡号
        NSString *cardId=[info objectForKey:@"cardId"];//卡的id
        NSString *password=[info objectForKey:@"passWd"];//支付密码
        
        strParam = [NSString stringWithFormat:@"?cardNo=%@&cardId=%@&payPass=%@",cardNum,cardId,password];
    }
    
    NSDictionary *dict = [self bsService:@"bindingVIPCard" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict)
    {
        //解析
        NSString *result =[self getStringByfunctionName:@"bindingVIPCard" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//绑定成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"绑定成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"cardNo"])//查不到会员卡
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"查不到会员卡",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"card"])//查不到会员信息
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"查不到会员信息",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"bind"])//卡号已绑定
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"卡号已绑定",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"pwd"])//密码错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"密码错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"message"])//信息不完整
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"信息不完整",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    
}

//首次绑定会员卡设置支付密码
-(NSDictionary *)updateCardPayPass:(NSMutableDictionary *)info
{
    NSString *payPass=[info objectForKey:@"payPass"];   //支付密码
    NSString *cardId=[info objectForKey:@"cardId"];    //卡Id
    NSString *cardNo=[info objectForKey:@"cardNo"];    //卡号
    
    NSString *name=[info objectForKey:@"name"];      //姓名
    NSString *mobtel=[info objectForKey:@"tele"];    //手机号码
    NSString *idNo=[info objectForKey:@"idNo"];      //正价号码
    NSString *credenTyp=[info objectForKey:@"credenTyp"]; //证件类型
    
    
    NSString *strParam;
    if([credenTyp isEqualToString:@""] || [idNo isEqualToString:@""])
    {
        strParam = [NSString stringWithFormat:@"?payPass=%@&cardId=%@&cardNo=%@&name=%@&mobtel=%@",payPass,cardId,cardNo,name,mobtel];
    }
    else
    {
        strParam = [NSString stringWithFormat:@"?payPass=%@&cardId=%@&cardNo=%@&name=%@&mobtel=%@&idNo=%@&credenTyp=%@",payPass,cardId,cardNo,name,mobtel,idNo,credenTyp];
    }
    
    
    NSDictionary *dict = [self bsService:@"updateCardPayPass" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict)
    {
        //解析
        NSString *result =[self getStringByfunctionName:@"updateCardPayPass" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"支付密码设置成功",@"Message", nil];
        }
        else if ([result isEqualToString:@"cardNo"])//查不到会员卡
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"查不到会员卡",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"card"])//查不到会员信息
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"查不到会员信息",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"bind"])//卡号已绑定
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"卡号已绑定",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"pwd"])//密码错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"密码错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"message"])//信息不完整
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"信息不完整",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"支付密码设置失败",@"Message", nil];
        }
        
        return dicResult;
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    
}

//获取已经绑定的会员卡信息
-(NSDictionary *)queryBindCard:(NSString *)cardPhone
{
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@",cardPhone];
    
    NSDictionary *dict = [self bsService:@"queryBindCard" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict)
    {
        //解析
        NSString *result =[self getStringByfunctionName:@"queryBindCard" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult=[[NSMutableArray alloc]init];
        
        NSString *key=[[[[dic objectForKey:@"listTele"] objectForKey:@"listCard"]allKeys] firstObject];
        if([key isEqualToString:@"text"]|| [result isEqualToString:@"listTele"])
        {
            aryResult=[[[dic objectForKey:@"listTele"] objectForKey:@"listCard"] objectForKey:@"text"];
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message",[NSNumber numberWithBool:YES],@"isNULL", nil];
            
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Card"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dic objectForKey:@"listTele"] objectForKey:@"listCard"] objectForKey:@"com.choice.webService.domain.Card"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listCard"] objectForKey:@"com.choice.webService.domain.Card"];
            }
        }
        
        if ([aryResult count] > 0)
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message",[NSNumber numberWithBool:NO],@"isNULL", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",aryResult,@"Message",[NSNumber numberWithBool:NO],@"isNULL", nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//获取优惠信息地区
-(NSDictionary *)getArea{
    //192.168.0.224:8081/CTF/webService/APPWebService/queryArea
    NSDictionary *dict = [self bsService:@"queryArea" arg:nil arg2:@"CTF/webService/APPWebService/"];
    //getCity
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryArea" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult = [[[dic objectForKey:@"listTele"] objectForKey:@"listFavorArea"] objectForKey:@"com.choice.webService.domain.FavorArea"];
        if([result isEqualToString:@"false"])
        {
             return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"获取信息失败",@"Message", nil];
        }
        else if ([result isEqualToString:@"listTele"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"暂无地区信息",@"Message", nil];
        }
        else if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"未知错误",@"Message", nil];
        }
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//根据地区获取优惠信息
-(NSDictionary *)getFavorableByAreaList:(NSString *)strArea{
    NSString *strParam = [NSString stringWithFormat:@"?favorareaid=%@",strArea];
    NSDictionary *dict = [self bsService:@"queryWebMsgByArea" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        //解析
        NSString *result =[self getStringByfunctionName:@"queryWebMsgByArea" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        
        NSMutableArray *aryResult = [[dic objectForKey:@"list"] objectForKey:@"com.choice.webService.domain.WebMsg"];
        
        if([result isEqualToString:@"false"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"获取信息失败",@"Message", nil];
        }
        else if ([result isEqualToString:@"list"])
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"该地区暂无优惠信息",@"Message", nil];
        }
        else if ([aryResult count] > 0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryResult,@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"未知错误",@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//根据优惠信息列表获取详细优惠信息
-(NSDictionary *)getInfoByFavorable:(NSString *)strFavor{
    
    return nil;
}


+(UIView *)callPhoneOrtele:(NSString *)phoneOrTele
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneOrTele]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    return callWebview;
}

//在线订位信息提交
-(NSDictionary *)sendTableMessage:(NSMutableDictionary *)Info
{
    //    dat :日期    sft：餐次  mobtel：手机号  type：1：大厅 0：包间   idorpax：名称  firmid ：门店id clientid：客户id
    
    NSString *strParam = [NSString stringWithFormat:@"?dat=%@&sft=%@&mobtel=%@&type=%@&idOrPax=%@&firmId=%@&clientId=%@&pax=%@&datmins=%@",[Info objectForKey:@"dat"],[Info objectForKey:@"sft"],[Info objectForKey:@"mobtel"],[Info objectForKey:@"type"],[Info objectForKey:@"idorpax"],[Info objectForKey:@"firmId"],[Info objectForKey:@"clientId"],[Info objectForKey:@"pax"],[Info objectForKey:@"datmins"]];
    NSDictionary *dict = [self bsService:@"saveResvOrder" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"saveResvOrder" andDict:dict];
        if (result) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",result,@"Message", nil];
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",result,@"Message", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}

//判断手机号已注册，返回该手机号下注册信息
-(NSDictionary *)getUserPersonMessage:(NSMutableDictionary *)Info
{
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@",[Info objectForKey:@"mobtel"]];
    NSDictionary *dict = [self bsService:@"queryCardByMobtel" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryCardByMobtel" andDict:dict];
        NSDictionary *dic = [BSWebServiceAgent parseXmlResult:result];
        if (dic) {
            NSString  *key=[[[[dic objectForKey:@"listTele"]objectForKey:@"listCard"]allKeys]firstObject];
            if([key isEqualToString:@"text"])
            {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",dic,@"Message",[NSNumber numberWithBool:YES],@"isNULL", nil];
            }
            else
            {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",dic,@"Message",[NSNumber numberWithBool:NO],@"isNULL", nil];
            }
        }else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",dic,@"Message",[NSNumber numberWithBool:NO],@"isNULL", nil];
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message",[NSNumber numberWithBool:NO],@"isNULL", nil];
    }
    return nil;
}


//解除会员卡绑定
-(NSDictionary *)removeBindCard:(NSMutableDictionary *)Info
{
    NSString *strParam = [NSString stringWithFormat:@"?cardNo=%@&flag=%@",[Info objectForKey:@"cardNum"],[Info objectForKey:@"flag"]];
    NSDictionary *dict = [self bsService:@"removeBindCard" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"removeBindCard" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//解除绑定成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"绑定成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//信息不完整
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"解除绑定绑定失败",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}


//移除所有的会员卡，即忘记密码，让用户重新添加会员卡
-(NSDictionary *)forgetPassword:(NSMutableDictionary *)Info
{
    
    NSString    *phone=[Info objectForKey:@"phone"];
    
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@",phone];
    NSDictionary *dict = [self bsService:@"forgetPassword" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"forgetPassword" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"修改成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"填写信息错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}

//修改支付密码
-(NSDictionary *)replacePassWord:(NSMutableDictionary *)Info
{
    NSString    *old=[Info objectForKey:@"old"];
    NSString    *new=[Info objectForKey:@"new"];
    NSString    *phone=[Info objectForKey:@"phone"];
    
    NSString *strParam = [NSString stringWithFormat:@"?newPassWd=%@&mobtel=%@&oldPassWd=%@",new,phone,old];
    NSDictionary *dict = [self bsService:@"changePayPass" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"changePayPass" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"修改成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"old"])//原密码错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"原密码错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"mobtel"])//手机号码错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"手机号码非办卡预留手机号码",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"填写信息错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//获取会员卡的规则
-(NSDictionary *)getCardResult
{
    NSString *strParam = [NSString stringWithFormat:@""];
    NSDictionary *dict = [self bsService:@"getCardRules" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getCardRules" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if(dictValue)//获取成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:dictValue,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"null",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//查询会员充值记录
-(NSDictionary *)queryChargeRecord:(NSMutableDictionary *)Info
{
    NSString *cardId = [Info objectForKey:@"cardId"];
    NSString *startDate = [Info objectForKey:@"startDate"];
    NSString *endDate = [Info objectForKey:@"endDate"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?cardId=%@&startDate=%@&endDate=%@",cardId,startDate,endDate];
    NSDictionary *dict = [self bsService:@"queryChargeRecord" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryChargeRecord" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if([[[[[dictValue objectForKey:@"listTele"] objectForKey:@"listChargeRecord"]allKeys] firstObject]isEqualToString:@"text"])
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.ChargeRecord"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listChargeRecord"] objectForKey:@"com.choice.webService.domain.ChargeRecord"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listChargeRecord"] objectForKey:@"com.choice.webService.domain.ChargeRecord"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//查询会员消费记录
-(NSDictionary *)queryConsumeRecord:(NSMutableDictionary *)Info
{
    NSString *cardId = [Info objectForKey:@"cardId"];
    NSString *startDate = [Info objectForKey:@"startDate"];
    NSString *endDate = [Info objectForKey:@"endDate"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?cardId=%@&startDate=%@&endDate=%@",cardId,startDate,endDate];
    NSDictionary *dict = [self bsService:@"queryConsumeRecord" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryConsumeRecord" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if([[[[[dictValue objectForKey:@"listTele"] objectForKey:@"listConsumeRecord"]allKeys] firstObject]isEqualToString:@"text"])
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.ConsumeRecord"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listConsumeRecord"] objectForKey:@"com.choice.webService.domain.ConsumeRecord"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listConsumeRecord"] objectForKey:@"com.choice.webService.domain.ConsumeRecord"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}


//查询会员卡的电子卷

-(NSDictionary *)queryVoucher:(NSMutableDictionary *)Info
{
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    
    NSString *strParam = [NSString stringWithFormat:@"?cardId=%@",[Info objectForKey:@"cardId"]];
    NSDictionary *dict = [self bsService:@"queryVoucher" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"queryVoucher" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if([[[[[dictValue objectForKey:@"listTele"] objectForKey:@"listVoucher"]allKeys] firstObject]isEqualToString:@"text"])
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Voucher"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listVoucher"] objectForKey:@"com.choice.webService.domain.Voucher"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listVoucher"] objectForKey:@"com.choice.webService.domain.Voucher"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//获取我的预订
-(NSDictionary *)getOrderMenus:(NSMutableDictionary *)Info
{
    NSString *cardId=[Info objectForKey:@"userId"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?cardId=%@",cardId];
    NSDictionary *dict = [self bsService:@"getOrderByMobtel" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getOrderByMobtel" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Net__Orders"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listNet__Orders"] objectForKey:@"com.choice.webService.domain.Net__Orders"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listNet__Orders"] objectForKey:@"com.choice.webService.domain.Net__Orders"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//取消预订
-(NSDictionary *)cancelOrder:(NSMutableDictionary *)Info
{
    NSString    *orderId=[Info objectForKey:@"orderId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?orderId=%@",orderId];
    NSDictionary *dict = [self bsService:@"cancelOrder" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"cancelOrder" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"修改成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"取消失败",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
    
}

//获取所有排队叫号的结果
-(NSDictionary *)findMyWait:(NSMutableDictionary *)Info
{
    NSString *phone = [Info objectForKey:@"Phone"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@",phone];
    NSDictionary *dict = [self bsService:@"findMyWait" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"findMyWait" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.MyWait"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listMyWait"] objectForKey:@"com.choice.webService.domain.MyWait"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listMyWait"] objectForKey:@"com.choice.webService.domain.MyWait"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//获取排队叫号的门店列表
-(NSDictionary *)getFirmLine:(NSDictionary *)Info
{
    NSString *areaId = [Info objectForKey:@"areaId"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?area=%@",areaId];
    NSDictionary *dict = [self bsService:@"getFirmLine" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getFirmLine" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Firm"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//获取排队叫号的门店台位类型
-(NSDictionary *)findPaxByFirm:(NSMutableDictionary *)Info
{
    
    NSString *firmid = [Info objectForKey:@"firmid"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?firmid=%@",firmid];
    NSDictionary *dict = [self bsService:@"findPaxByFirm" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"findPaxByFirm" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Firm"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listFirm"] objectForKey:@"com.choice.webService.domain.Firm"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//会员卡密码验证
-(NSDictionary *)checkPassWd:(NSMutableDictionary *)Info
{
    NSString    *mobtel=[Info objectForKey:@"mobtel"];
    NSString    *passWd=[Info objectForKey:@"passWd"];
    
    NSString *strParam = [NSString stringWithFormat:@"?mobtel=%@&passWd=%@",mobtel,passWd];
    NSDictionary *dict = [self bsService:@"checkPassWd" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"checkPassWd" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"1"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"验证  成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"0"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"密码错误",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}

//获取排队叫号结果
-(NSDictionary *)addlineNo:(NSMutableDictionary *)Info
{
    NSString *firmId = [Info objectForKey:@"firmid"];
    NSString *pax=[Info objectForKey:@"pax"];
    NSString *mobtel=[Info objectForKey:@"mobtel"];
    NSString *cardId=[Info objectForKey:@"userId"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@&pax=%@&mobtel=%@&cardId=%@",firmId,pax,mobtel,cardId];
    NSDictionary *dict = [self bsService:@"addLineno" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"addLineno" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.WaitMessage"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listWaitMessage"] objectForKey:@"com.choice.webService.domain.WaitMessage"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listWaitMessage"] objectForKey:@"com.choice.webService.domain.WaitMessage"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
}

//删除叫号信息
-(NSDictionary *)cancleWait:(NSMutableDictionary *)Info
{
    NSString  *orderId=[Info objectForKey:@"orderId"];
    
    NSString *strParam = [NSString stringWithFormat:@"?id=%@",orderId];
    NSDictionary *dict = [self bsService:@"cancleWait" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"cancleWait" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"success"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"修改成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"取消失败",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}


//根据账单号获取
-(NSDictionary *)getOrderDetail:(NSMutableDictionary *)Info
{
    NSString *orderId = [Info objectForKey:@"orderId"];
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    NSString *strParam = [NSString stringWithFormat:@"?orderId=%@",orderId];
    NSDictionary *dict = [self bsService:@"getOrderDetail" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getOrderDetail" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Project"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listProject"] objectForKey:@"com.choice.webService.domain.Project"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//获取广告urlimage地址
-(NSDictionary *)findPic
{
    NSDictionary *dict = [self bsService:@"findPic" arg:nil arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"findPic" andDict:dict];
        NSMutableDictionary *dicResult;
        if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"nodata"])//填写信息错误
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"没有数据",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:result,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;
}


//获取品牌
-(NSDictionary *)getBrands
{
    NSDictionary *dict = [self bsService:@"getBrands" arg:nil arg2:@"CTF/webService/APPWebService/"];
    //getCity
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getBrands" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.Brand"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listBrands"] objectForKey:@"com.choice.webService.domain.WaitMessage"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listBrands"] objectForKey:@"com.choice.webService.domain.Brand"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;
    
}

//获取评分栏目
-(NSDictionary *)getEvalColumn
{
    NSDictionary *dict = [self bsService:@"getEvalColumn" arg:nil arg2:@"CTF/webService/APPWebService/"];
    //getCity
    NSMutableArray  *aryResult=[[NSMutableArray alloc]init];
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"getEvalColumn" andDict:dict];
        NSDictionary *dictValue=[BSWebServiceAgent parseXmlResult:result];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSArray *array = [result componentsSeparatedByString:@"com.choice.webService.domain.app.EvalColumn"];
            if([array count]<=2)
            {
                NSDictionary *dic2 = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listEvalColumn"] objectForKey:@"com.choice.webService.domain.app.EvalColumn"];
                if(dic2!=nil)
                {
                    [aryResult addObject:dic2];
                }
            }
            else
            {
                aryResult = [[[dictValue objectForKey:@"listTele"] objectForKey:@"listEvalColumn"] objectForKey:@"com.choice.webService.domain.app.EvalColumn"];
            }
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:aryResult,@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }    return nil;

}

//提交评价信息
-(NSDictionary *)saveEvaluation:(NSDictionary *)Info
{
    NSString  *firmId=[Info objectForKey:@"firmId"];
    NSString  *score=[Info objectForKey:@"score"];
    NSString *content;
    if([Info objectForKey:@"content"])
    {
        content=[Info objectForKey:@"content"];
    }
    else
    {
        content=@"无";
    }
    NSString *cardId=[Info objectForKey:@"cardId"];
    NSString *account=[Info objectForKey:@"account"];
    NSString *evaltyp =@"1";//默认值1，表示门店评价
    NSString  *membTyp=@"普通会员";////默认值普通会员
    NSString  *scoredtl=[Info objectForKey:@"scoredtl"];
    
    NSString *strParam = [NSString stringWithFormat:@"?firmId=%@&score=%@&content=%@&cardId=%@&account=%@&membTyp=%@&evaltyp=%@&scoredtl=%@",firmId,score,content,cardId,account,membTyp,evaltyp,scoredtl];
    NSDictionary *dict = [self bsService:@"saveEvaluation" arg:strParam arg2:@"CTF/webService/APPWebService/"];
    
    if (dict) {
        NSString *result =[self getStringByfunctionName:@"saveEvaluation" andDict:dict];
        NSMutableDictionary *dicResult;
        if([result isEqualToString:@"true"])//修改成功
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"修改成功",@"Message",[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else if ([result isEqualToString:@"false"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"当前网络不稳定，请重试",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else if ([result isEqualToString:@"fail"])//当前网络不稳定，请重试
        {
            dicResult =[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"提交评价信息失败",@"Message",[NSNumber numberWithBool:NO],@"Result", nil];
        }
        else
        {
            NSLog(@"无此判断类型");
        }
        return dicResult;
        
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
    return nil;

}

//根据返回标示确认是否需要调用升级客户端。
-(NSDictionary *)isTypUpdateWebService:(NSString *)version andXml:(NSString *)xmlStr
{
    xmlStr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",version];
    NSString *strParam = [NSString stringWithFormat:@"?version=%@&code=10000&typ=IPAD&xmlStr=%@",version,[DataProvider md5:xmlStr]];
    NSDictionary *dict = [self bsService:@"isTypUpdateWebService" arg:strParam arg2:@""];
    if(dict)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[[[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:isTypUpdateWebServiceResponse"] objectForKey:@"return"]objectForKey:@"text"],@"Message", nil];
    }
    else
    {
       return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }
}


//根据返回值展示更新内容
-(NSDictionary *)getTypUpdateCont:(NSString *)version andxmlStr:(NSString *)xmlStr
{
    xmlStr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",version];
    NSString *strParam = [NSString stringWithFormat:@"?version=%@&code=10000&typ=IPAD&xmlStr=%@",version,[DataProvider md5:xmlStr]];
    NSDictionary *dict = [self bsService:@"getTypUpdateCont" arg:strParam arg2:@""];
    if(dict)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[[[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:getTypUpdateContResponse"] objectForKey:@"return"]objectForKey:@"text"],@"Message", nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }

}

//	获取更地址
-(NSDictionary *)findVersionPADWebService:(NSString *)version andxmlStr:(NSString *)xmlStr
{
    xmlStr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",version];
    NSString *strParam = [NSString stringWithFormat:@"?version=%@&code=10000&typ=IPAD&xmlStr=%@",version,[DataProvider md5:xmlStr]];
    NSDictionary *dict = [self bsService:@"findVersionPADWebService" arg:strParam arg2:@""];
    if(dict)
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[[[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:findVersionPADWebServiceResponse"] objectForKey:@"return"]objectForKey:@"text"],@"Message", nil];
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",strNetwork,@"Message", nil];
    }

}

@end
