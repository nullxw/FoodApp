//
//  shareInfoData.h
//  Food
//
//  Created by dcw on 14-4-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shareInfoData : NSObject

+(shareInfoData *)shareInstance;

@property(nonatomic,copy) NSDictionary *dicStore;
@property(nonatomic,copy) NSString     *strCity;
@property(nonatomic,copy) NSString     *strDate;
@property(nonatomic,copy) NSString     *strTime;
@end
