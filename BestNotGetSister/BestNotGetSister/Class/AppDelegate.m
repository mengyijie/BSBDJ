//
//  AppDelegate.m
//  Confused
//
//  Created by 孟义杰 on 16/2/17.
//  Copyright © 2016年 孟义杰. All rights reserved.
//

#import "AppDelegate.h"
#import "MYJTabBarController.h"
#import "MYJTopWindow.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialRenrenHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [UMSocialData setAppKey:UMAPPkey];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1105260296" appKey:@"Rxts3bjCVhspC6LC" url:@"http://www.umeng.com/social"];
    //新浪微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2559129676"
                                              secret:@"fe090cf12466712cdc6e4c20d6c7ad07"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    //微信
    [UMSocialWechatHandler setWXAppId:@"wx6e99dd1200ba5132" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //人人
    [UMSocialRenrenHandler openSSO];
    //腾讯微博
    
    //状态栏(显示时间的那里)
    [MYJTopWindow show];
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置窗口的根控制器
    self.window.rootViewController = [[MYJTabBarController alloc] init];
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
