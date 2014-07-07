//
//  CVWebServiceAgent.h
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>


@interface BSWebServiceAgent : NSObject<NSXMLParserDelegate> {
    NSString *m_element;
    NSMutableArray *m_array;
    NSMutableDictionary *m_rootObject;
    NSMutableDictionary *m_object;
    
    NSString *strData;

}
@property (nonatomic,retain) NSString *strData;

- (NSDictionary *)GetData:(NSString *)api arg:(NSString *)arg arg2:(NSString *)arg2;
+(NSDictionary *)parseXmlResult:(NSString *)result;
-(NSString *)serviceUrlUpdata:(NSString *)api arg:(NSString *)arg ;
@end
