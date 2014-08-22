//
//  AppDelegate.m
//  Food
//
//  Created by dcw on 14-3-24.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "NewMenuViewController.h"

@implementation AppDelegate
{
    BMKMapManager* _mapManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    
    [DataProvider sharedInstance].App_version=@"0";
    
   
    
    [self _initNSUserDefaults];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"15552860566" forKey:@"userPhone"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *loginnvc;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue])
    {
//        MenuViewController *login = [[MenuViewController alloc] init];
        NewMenuViewController *login = [[NewMenuViewController alloc] init];
        loginnvc=[[UINavigationController alloc]initWithRootViewController:login];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.isChange=NO;
        loginnvc=[[UINavigationController alloc]initWithRootViewController:login];
       
    }
    
     loginnvc.navigationBar.hidden=YES;
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"45ri3wPdRuRQFpPW8mjx50sS" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window.rootViewController = loginnvc;
    [self.window makeKeyAndVisible];
    return YES;
}





//初始化NSUserDefaults
-(void)_initNSUserDefaults{
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *init = [[NSUserDefaults standardUserDefaults] objectForKey:@"init"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [myUserDefaults setObject:version forKey:@"version"];  //版本號
    if (init == nil) {
        [myUserDefaults setObject:@"init" forKey:@"init"];
        [myUserDefaults setObject:@"cn" forKey:@"language"];
    }
    [myUserDefaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.da
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
