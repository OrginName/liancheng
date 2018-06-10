//
//  AppDelegate.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ResumeController.h"
#import "ShowResumeController.h"
#import "YSLoginController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    
    if (kIsLogin) {
        BaseTabBarController *baseTabBar = [[BaseTabBarController alloc]init];
        //    ShowResumeController * baseTabBar = [ShowResumeController new];
        [self.window setRootViewController:baseTabBar];
    }else{
        YSLoginController *loginVC = [[YSLoginController alloc]init];
        BaseNavigationController * base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.window setRootViewController:base];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Receivetag) name:@"TABBAR" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backWindow) name:@"BACKMAINWINDOW" object:nil];
    //通知键盘弹出状态
    [self notify_addObserver];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = KGDMapKey;
    return YES;
}
//-(void)backWindow{
//    BaseTabBarController * baseTabBar = [[BaseTabBarController alloc] init];
//    [self.window setRootViewController:baseTabBar];
//}
//-(void)Receivetag{
//    BaseOneTabController * baseOneTabBar = [[BaseOneTabController alloc] init];
//    [self.window setRootViewController:baseOneTabBar];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //移除键盘弹出监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - NSNotification
- (void)notify_addObserver {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)notifyKeyboardDidShow:(NSNotification *)notification {
    self.keyboardDidShow = YES;
}

- (void)notifyKeyboardDidHide:(NSNotification *)notification {
    self.keyboardDidShow = NO;
}

@end
