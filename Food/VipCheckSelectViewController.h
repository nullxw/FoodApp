//
//  VipCheckSelectViewController.h
//  Food
//
//  Created by sundaoran on 14-4-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showDateView.h"

typedef  enum
{
//    视图选择
    CheckselectMoney,       //余额
    CheckselectSpecial,     //会员专享
    CheckselectIntegral,    //积分
    CheckselectCoupon,      //电子卷
    CheckselectSale,        //消费记录
    CheckselectRechange,    //充值记录
    CheckselectExplane,     //会员卡说明
    CheckselectApply,        //适用门店
    CheckselectAgreement    //用户协议
}Checkselect;

@interface VipCheckSelectViewController : UIViewController<navigationBarViewDeleGete,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


-(id)initWithCheckSelectType:(Checkselect)checkType andTitleName:(NSString *)title andsetResult:(NSDictionary *)result;


@end
