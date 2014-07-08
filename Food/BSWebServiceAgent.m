//
//  CVWebServiceAgent.m
//  CapitalVueHD
//
//  Created by jishen on 8/23/10.
//  Copyright 2010 SmilingMobile. All rights reserved.
//

#import "BSWebServiceAgent.h"
#import "DataProvider.h"
#import "XMLReader.h"
#import "AFNetworking.h"

@interface BSWebServiceAgent()
@property(nonatomic, retain) NSString *m_element;
@property(nonatomic, retain) NSMutableArray *m_array;
@property(nonatomic, retain) NSMutableDictionary *m_rootObject;
@property(nonatomic, retain) NSMutableDictionary *m_object;




- (NSDictionary *)parseXML:(NSString *)serviceUrl;
- (NSString *)serviceUrl:(NSString *)api arg:(NSString *)arg;


@end

@implementation BSWebServiceAgent

@synthesize m_element;
@synthesize m_array;
@synthesize m_rootObject;
@synthesize m_object;
@synthesize strData;

static NSDictionary *DICT_API_InterfazAdd = nil;
//static NSString *LOGIN_TOKEN = nil;

-(id)init{
    self = [super init];
    if (self) {
        if (DICT_API_InterfazAdd==nil) {
            NSString *plistPath;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            
            plistPath = [rootPath stringByAppendingPathComponent:@"apiList.plist"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
                plistPath = [[NSBundle mainBundle] pathForResource:@"apiList" ofType:@"plist"];
            }
            
            DICT_API_InterfazAdd = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
        }
        
    }
    return self;
}

- (void) dealloc {
    self.m_element = nil;
    self.m_array = nil;
    self.m_rootObject = nil;
    self.m_object = nil;
    self.strData = nil;

	[super dealloc];
}

//作用：拼接URL
//api是要调用WebServices方法的名字的对应值，对应着apiList文件
//arg是对应的参数
- (NSString *)serviceUrl:(NSString *)api arg:(NSString *)arg arg2:(NSString *)arg2{
//    NSString *strAPI = [DICT_API_InterfazAdd objectForKey:api];
    
//    NSDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ServerSettings"] objectForKey:@"api"];
//    NSString *str = [NSString stringWithFormat:@"http://222.175.157.61:8090/CTF/webService/CRMWebService/",[dict objectForKey:@"ip"],[dict objectForKey:@"port"]];
    
//    NSString *str = @"http://192.168.0.168:8081/CTF/webService/BOHWebService";
//    NSString *str = @"http://192.168.0.197:8081/";
    NSString *str;
    if([arg2 isEqualToString:@""])
    {
        str = [NSString stringWithFormat:@"%@/autoUpdateService/webService/autoService/%@?%@",[[DataProvider getIpPlist]objectForKey:@"checkUpadta"],api,arg];
    }
    else
    {
        str = [[DataProvider getIpPlist]objectForKey:@"APIURL"];
    }
    if (arg == nil) {
        return [NSString stringWithFormat:@"%@%@%@",str,arg2,api];
    }
    return [NSString stringWithFormat:@"%@%@%@%@",str,arg2,api,arg];
}




- (NSDictionary *)GetData:(NSString *)api arg:(NSString *)arg arg2:(NSString *)arg2{
	NSString *strUrl;
	
	strUrl = [self serviceUrl:api arg:arg arg2:arg2];
    NSLog(@"%@===>%@",api,strUrl);
    
	return [self parseXML:strUrl];
}

-(NSDictionary *)parseXML1:(NSString *)strUrl {
    
    NSCondition* itlock = [[NSCondition alloc] init];//搞个事件来同步下
    __block NSDictionary *dicInfo = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //设置下载完成调用的block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){
        //下载的字符串
//        NSLog(@"%@",operation.responseString);
        //如果是图片的话
        //NSLog(@"%@",operation.responseData);
        NSError *error = nil;
        dicInfo = [XMLReader dictionaryForXMLData:operation.responseData error:&error];
        NSLog(@"Service Data String:%@",dicInfo);
        if (error)
            NSLog(@"Parse XML Error:%@",error);
        
        [itlock lock];
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        [itlock unlock];
    }failure:^(AFHTTPRequestOperation* operation, NSError* error){
        NSLog( @"Server timeout!" );
        
        [itlock lock];
        [itlock signal];//失败也要设置事件,不然下面一直死等了
        [itlock unlock];
    }];
    //开始下载
    [operation start];
    
    [itlock lock];//启动AFNETWORKING之后就等待事件
    [itlock wait];
    [itlock unlock];
    
    return dicInfo;
}

//-(NSDictionary*)reqUtil:(NSString*)reqURLStr
//{
//    
//    NSCondition* itlock = [[NSCondition alloc] init];//搞个事件来同步下
//    
//    NSLog(@"reqstr:%@",reqURLStr);
//    __block NSDictionary* itret = nil;
//    
//    //AFNETWORKING 异步请求
//    [operation getPath:reqURLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //执行成功之后的BLOCK代码
//        
//        //得到了数据
//        JSONDecoder *jd=[[JSONDecoder alloc] init];
//        NSDictionary* tt = [jd objectWithData:responseObject];
//        itret = [[NSDictionary alloc] initWithDictionary:tt];
//        
//        [itlock lock];
//        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
//        [itlock unlock];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"neterr:%@",[error localizedDescription]);
////        [_delegate didFailedUpdateWithError:error];
//        
//        [itlock lock];
//        [itlock signal];//失败也要设置事件,不然下面一直死等了
//        [itlock unlock];
//        
//    }];
//    
//    [itlock lock];//启动AFNETWORKING之后就等待事件
//    [itlock wait];
//    [itlock unlock];
//    
//    return  itret;
//}

+(NSDictionary *)parseXmlResult:(NSString *)result{
    NSError *error = nil;
//    self.strData = [NSString stringWithCString:[serviceData bytes] encoding:NSUTF8StringEncoding];
//    NSDictionary* dicInfo = [XMLReader dictionaryForXMLData:serviceData error:&error];
    NSDictionary* dicInfo = [XMLReader dictionaryForXMLString:result error:&error];
    NSLog(@"Service Data String:%@",dicInfo);
    if (error)
        NSLog(@"Parse XML Error:%@",error);
    return dicInfo;
}

//请求WebServices 返回数据
-(NSDictionary *)parseXML:(NSString *)serviceUrl {
    NSDictionary *dicInfo = nil;
    
    NSURL *url = nil;
    NSMutableURLRequest *request = nil;

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *serviceData = nil;

    url = [[NSURL alloc] initWithString:[serviceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    request = [[NSMutableURLRequest alloc] initWithURL:url
                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:20.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"gzip" forHTTPHeaderField:@"accept-encoding"];
        
    serviceData = [NSURLConnection sendSynchronousRequest:request 
                                            returningResponse:&response
                                                        error:&error];
    // 1001 is the error code for a connection timeout
    if (error && [error code] == 1001 ) {
        NSLog( @"Server timeout!" );
    } else if (serviceData) {
        NSError *error = nil;
        self.strData = [NSString stringWithCString:[serviceData bytes] encoding:NSUTF8StringEncoding];
        dicInfo = [XMLReader dictionaryForXMLData:serviceData error:&error];
//        dicInfo = [XMLReader dictionaryForXMLString:serviceData error:&error];
        NSLog(@"Service Data String:%@",dicInfo);
        if (error)
            NSLog(@"Parse XML Error:%@",error);
    }    
                
    [url release];
    [request release];
    
	return dicInfo;
}

#pragma mark XMLParser delegate

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName 
	forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSUInteger count;
	NSMutableDictionary *dict;
	NSMutableString *strValue;
	count = [self.m_object count];
	if (0 == count) {
		// an empty object, so create it
		dict = [[NSMutableDictionary alloc] init];
		[dict setObject:string forKey:@"value"];
		self.m_object = dict;
		[dict release];
	} else {
		// it is not empty
		// get the existing value and append string to it
		strValue = [[NSMutableString alloc] init];
		if (nil == [m_object objectForKey:@"value"]) {
			[strValue setString:string];
		} else {
			[strValue setString:[m_object objectForKey:@"value"]];
			[strValue appendString:string];
		}
		[m_object setObject:strValue forKey:@"value"];
		[strValue release];
	}
    

	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {		
	
	[m_array addObject:m_object];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
	// take the attributeDict as a pair of key and value of an object
	self.m_object = dict;
	self.m_element = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	NSMutableDictionary *dict;
	
	// get the last object of the array
	dict = [m_array lastObject];
	
	if ([dict objectForKey:elementName] != nil)
	{
		// if there is an object with the same key in the upper level dictionary
		id upperObj = [dict objectForKey:elementName];
		
		if ( [upperObj isKindOfClass:[NSMutableArray class]] )
		{
			// the upper object is an array
			[(NSMutableArray *)upperObj addObject:m_object];
		}
		else
		{
			// the upper object is not an array, but the current object and 
			// and uppper object shares the common attribute, so construct an
			// array to hold them.
			NSMutableArray * newArray = [[NSMutableArray alloc] initWithCapacity:2];
			[newArray addObject:upperObj];
			[newArray addObject:m_object];
			
			[dict removeObjectForKey:elementName];
			[dict setObject:newArray forKey:elementName];
			[newArray release];
		}
	}
	else
	{
		[dict setObject:m_object forKey:elementName];
	}
	
	// pop current dictionary
	self.m_object = [m_array lastObject];
	[m_array removeLastObject];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	self.m_object = m_rootObject;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

@end
