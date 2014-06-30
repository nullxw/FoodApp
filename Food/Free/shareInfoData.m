//
//  shareInfoData.m
//  Food
//
//  Created by dcw on 14-4-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "shareInfoData.h"

@implementation shareInfoData

@synthesize dicStore,strCity,strTime,strDate;

static shareInfoData *sharedInstance = nil;
+ (shareInfoData *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[shareInfoData alloc] init];
        }
    }
    return sharedInstance;
}

@end
