//
//  Chracter.h
//  PhoneBook
//
//  Created by apple on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chracter : NSObject
{
    NSArray *allChracter;
}

@property(strong,nonatomic) NSArray *allChracter;

-(NSString *)getFirstChracter:(NSString *)strText;

@end
