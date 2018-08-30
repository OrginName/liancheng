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
#import <AudioToolbox/AudioToolbox.h>
//#import <RongCallKit/RongCallKit.h>
#import <RongIMKit/RongIMKit.h>
#import <RongContactCard/RongContactCard.h>
#import "MobClick.h"
#import "RCDSettingUserDefaults.h"
#import "privateUserInfoModel.h"
#import "RCDRCIMDataSource.h"
#import "RCWKNotifier.h"
#import "RCWKRequestHandler.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "OurServiceController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#import "NoticeController.h"
#import "RCDAddressBookViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define IsProduction 0
#define JpushAppKey @"06ead6e422830a9523255984"
#define QQ_APPID @"1106473725"
#define QQ_APPKEY @"dTrtNRCsVY79nCwC"
#define APPID_WEIXIN @"wxb773a629b959a9f9"
#define APPSECRET_WEIXIN @"682ffe7c6b89c8eea9f30862ebdfc1ce"
#define RONGCLOUD_IM_APPKEY @"3argexb63m7xe"// online key
#define UMENG_APPKEY @"5b4a423c8f4a9d1b3a00047e"
#define LOG_EXPIRE_TIME -7 * 24 * 60 * 60
@interface AppDelegate ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,RCWKAppInfoProvider,WXApiDelegate,JPUSHRegisterDelegate,CustomLocationDelegate>
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController *vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    self.location = [[CustomLocatiom alloc] init];
    _location.delegate = self;
    [self umengTrack];
    //非debug模式初始化sdk
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    // 注册自定义测试消息
//    [[RCIM sharedRCIM] registerMessageType:[RCDTestMessage class]];
    //设置会话列表头像和会话页面头像
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    //设置名片消息功能中联系人信息源和群组信息源
    [RCContactCardKit shareInstance].contactsDataSource = RCDDataSource;
    [RCContactCardKit shareInstance].groupDataSource = RCDDataSource;
    
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
//      [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
//      [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =
    @[ @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP) ];
    
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //  设置头像为圆形
    //  [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //  [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //   设置优先使用WebView打开URL
    //  [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
    
    //  设置通话视频分辨率
    //  [[RCCallClient sharedRCCallClient] setVideoProfile:RC_VIDEO_PROFILE_480P];
    
    //设置Log级别，开发阶段打印详细log
//    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:RCKitDispatchMessageNotification
                                               object:nil];
    //登录
    NSString *token = [KUserDefults objectForKey:@"userToken"];
    NSString *userId = [KUserDefults objectForKey:@"userId"];
//    NSString *userName = [KUserDefults objectForKey:@"userName"];
    NSString *password = [KUserDefults objectForKey:@"userPwd"];
    NSString *userNickName = [KUserDefults objectForKey:@"userNickName"];
    NSString *userPortraitUri = [KUserDefults objectForKey:@"userPortraitUri"];
    if (token.length && userId.length && password.length) {
        BaseTabBarController *baseTabBar = [[BaseTabBarController alloc]init];
        //    ShowResumeController * baseTabBar = [ShowResumeController new];
        [self.window setRootViewController:baseTabBar];
//        [self insertSharedMessageIfNeed];
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId name:userNickName portrait:userPortraitUri];
        [RCIM sharedRCIM].currentUserInfo = _currentUserInfo;
        [[RCIM sharedRCIM] connectWithToken:token
                                    success:^(NSString *userId) {
                                        [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
                                            privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
                                            userInfoModel.ID = responseObject[@"data"][@"id"];
                                            [YSAccountTool saveUserinfo:userInfoModel];
                                            RCUserInfo * user = [[RCUserInfo alloc] initWithUserId:userInfoModel.modelId name:userInfoModel.nickName?userInfoModel.nickName:userInfoModel.modelId portrait:userInfoModel.headImage];
                                            //登录demoserver成功之后才能调demo 的接口
                                            [RCDDataSource syncGroups];
                                            [RCDDataSource syncFriendList:userId
                                                                 complete:^(NSMutableArray *result){
                                                                 }];
                                            [KUserDefults setObject:user.portraitUri forKey:@"userPortraitUri"];
                                            [KUserDefults setObject:user.name forKey:@"userNickName"];
                                            [KUserDefults synchronize];
                                        } failure:nil];
                                    }
                                      error:^(RCConnectErrorCode status) {
                                          
                                      }
                             tokenIncorrect:^{
                                 [self gotoLoginViewAndDisplayReasonInfo:@"登录失效，请重新登录"];
                             }];
        
    } else {
        YSLoginController *loginVC = [[YSLoginController alloc]init];
        BaseNavigationController * base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.window setRootViewController:base];
    }
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:@"App Store"
                 apsForProduction:IsProduction
            advertisingIdentifier:nil];
    /**
     * 推送处理1
     */
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes =
        UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    /**初始化ShareSDK应用
     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:APPID_WEIXIN
                                       appSecret:APPSECRET_WEIXIN];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_APPID
                                      appKey:QQ_APPKEY
                                    authType:SSDKAuthTypeBoth];
                 break;
                                                 default:
                   break;
                   }
                   }];
    //注册微信支付
    [WXApi registerApp:APPID_WEIXIN];
    //开始监听网络状态
    [YSNetworkTool startMonitorNetwork];
    //通知键盘弹出状态
    [self notify_addObserver];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey = KGDMapKey;
     
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIFont *font = [UIFont systemFontOfSize:18.f];
    NSDictionary *textAttributes = @{
                                     
                                     NSFontAttributeName : font,
                                     
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     
                                     };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
    return YES;
}
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""] stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您的帐号在别的设备上登录，"
                              @"您被迫下线！"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        YSLoginController *loginVC = [[YSLoginController alloc] init];
        BaseNavigationController *_navi = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
#warning token无效的方法
//        [AFHttpTool getTokenSuccess:^(id response) {
//            NSString *token = response[@"result"][@"token"];
//            [[RCIM sharedRCIM] connectWithToken:token
//                                        success:^(NSString *userId) {
//
//                                        }
//                                          error:^(RCConnectErrorCode status) {
//
//                                          }
//                                 tokenIncorrect:^{
//
//                                 }];
//        }
//                            failure:^(NSError *err){
//
//                            }];
    } else if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        [[RCIMClient sharedRCIMClient] disconnect];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您的帐号被封禁"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        YSLoginController *loginVC = [[YSLoginController alloc] init];
        BaseNavigationController *_navi = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#if TARGET_IPHONE_SIMULATOR
    // 模拟器不能使用远程推送
#else
    // 请检查App的APNs的权限设置，更多内容可以参考文档
    // http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
#endif
}
//友盟设置
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES]; // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString *
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy)REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App
    //   Store"渠道
    [MobClick updateOnlineConfig]; //在线参数配置
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onlineConfigCallBack:)
                                                 name:UMOnlineConfigDidFinishedNotification
                                               object:nil];
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

// iOS 10 Support 前台收到的
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
    }
    NSArray * arr = @[@"10",@"20",@"30",@"40"];
    if (![userInfo[@"rc"][@"oName"] isEqualToString:@"RC:TxtMsg"]) {
        if([arr containsObject:[userInfo[@"type"] description]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JOINACTIVE" object:@{@"num":@"1"}];
        }else if ([[userInfo[@"type"] description] isEqualToString:@"2"]||[[userInfo[@"type"] description] isEqualToString:@"4"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MYSERVICE" object:@{@"num":@"1",@"type":[userInfo[@"type"] description]}];
        }else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TSJBACTIVE" object:@{@"num":@"1"}];
    } 
}
// iOS 10 Support
//#ifdef __IPHONE_10_0  //后台收到的
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    
    [self gotoNextPage:userInfo];
    completionHandler();  // 系统要求执行这个方法
}
-(void)gotoNextPage:(NSDictionary *)userInfo{
    NSArray * arr = @[@"10",@"20",@"30",@"40"];
    // 融云目前用到的消息类型  RC:TxtMsg RC:ImgMsg RC:CardMsg RC:FileMsg RC:VcMsg
    if ([userInfo[@"rc"][@"cType"] isEqualToString:@"PR"]) {
        BaseTabBarController *tabBar = (BaseTabBarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
        tabBar.selectedIndex = 1;
    }else if([arr containsObject:[userInfo[@"type"] description]]){
        RCDAddressBookViewController * address = [RCDAddressBookViewController new];
        BaseTabBarController *tabBar = (BaseTabBarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[BaseTabBarController class]]) {//判断是否是当前根视图
            UINavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:address animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else if ([[userInfo[@"type"] description] isEqualToString:@"2"]||[[userInfo[@"type"] description] isEqualToString:@"4"]){
        OurServiceController * service = [OurServiceController new];
        service.inter = [[userInfo[@"type"] description] isEqualToString:@"2"]?1:2;
        BaseTabBarController *tabBar = (BaseTabBarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[BaseTabBarController class]]) {//判断是否是当前根视图
            UINavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:service animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        
    }else{
        NoticeController * notice = [NoticeController new];
        notice.title = @"消息";
        BaseTabBarController *tabBar = (BaseTabBarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[BaseTabBarController class]]) {//判断是否是当前根视图
            UINavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:notice animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}
//#endif
/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
     [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSLog(@"应用程序在前台");
        NSArray * arr = @[@"10",@"20",@"30",@"40"];
        if (![userInfo[@"rc"][@"oName"] isEqualToString:@"RC:TxtMsg"]) {
            if([arr containsObject:[userInfo[@"type"] description]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"JOINACTIVE" object:@{@"num":@"1"}];
            }else if ([[userInfo[@"type"] description] isEqualToString:@"2"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYSERVICE" object:@{@"num":@"1"}];
            }else if ([[userInfo[@"type"] description] isEqualToString:@"4"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MYTRVAL" object:@{@"num":@"1"}];
            }else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TSJBACTIVE" object:@{@"num":@"1"}];
        } 
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        [self gotoNextPage:userInfo];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    //  //震动
    //  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //  AudioServicesPlaySystemSound(1007);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
                                                                             ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    //  int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    //    @(ConversationType_PRIVATE),
    //    @(ConversationType_DISCUSSION),
    //    @(ConversationType_APPSERVICE),
    //    @(ConversationType_PUBLICSERVICE),
    //    @(ConversationType_GROUP)
    //  ]];
    //  application.applicationIconBadgeNumber = unreadMsgCount;
    
    // 登陆状态下为消息分享保存会话信息
    if([RCIMClient sharedRCIMClient].getConnectionStatus == ConnectionStatus_Connected){
        [self saveConversationInfoForMessageShare];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
        [self insertSharedMessageIfNeed];
    }
    self.location = [[CustomLocatiom alloc] init];
    _location.delegate = self;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXApi handleOpenURL:url delegate:weakSelf];
        [weakSelf alipayWithURL:url];
    });
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXApi handleOpenURL:url delegate:weakSelf];
        [weakSelf alipayWithURL:url];
    });
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXApi handleOpenURL:url delegate:weakSelf];
        [weakSelf alipayWithURL:url];
    });
    return YES;
}
//插入分享消息
- (void)insertSharedMessageIfNeed {
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    
    NSArray *sharedMessages = [shareUserDefaults valueForKey:@"sharedMessages"];
    if (sharedMessages.count > 0) {
        for (NSDictionary *sharedInfo in sharedMessages) {
            RCRichContentMessage *richMsg = [[RCRichContentMessage alloc] init];
            richMsg.title = [sharedInfo objectForKey:@"title"];
            richMsg.digest = [sharedInfo objectForKey:@"content"];
            richMsg.url = [sharedInfo objectForKey:@"url"];
            richMsg.imageURL = [sharedInfo objectForKey:@"imageURL"];
            richMsg.extra = [sharedInfo objectForKey:@"extra"];
            //      long long sendTime = [[sharedInfo objectForKey:@"sharedTime"] longLongValue];
            //      RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:[[sharedInfo
            //      objectForKey:@"conversationType"] intValue] targetId:[sharedInfo objectForKey:@"targetId"]
            //      sentStatus:SentStatus_SENT content:richMsg sentTime:sendTime];
            RCMessage *message = [[RCIMClient sharedRCIMClient]
                                  insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue]
                                  targetId:[sharedInfo objectForKey:@"targetId"]
                                  sentStatus:SentStatus_SENT
                                  content:richMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCDSharedMessageInsertSuccess" object:message];
        }
        [shareUserDefaults removeObjectForKey:@"sharedMessages"];
        [shareUserDefaults synchronize];
    }
}
//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList =
    [[RCIMClient sharedRCIMClient] getConversationList:@[ @(ConversationType_PRIVATE), @(ConversationType_GROUP) ]];
    
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            } else if (conversation.conversationType == ConversationType_GROUP) {
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager]
                        containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}

- (void)redirectNSlogToDocumentFolder {
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    [self removeExpireLogFiles:documentDirectory];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}
#pragma mark - RCWKAppInfoProvider
- (NSString *)getAppName {
    return @"融云";
}

- (NSString *)getAppGroups {
    return @"group.cn.rongcloud.im.WKShare";
}

- (NSArray *)getAllUserInfo {
    return [RCDDataSource getAllUserInfo:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitUserInfoChanged];
    }];
}
- (NSArray *)getAllGroupInfo {
    return [RCDDataSource getAllGroupInfo:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitGroupChanged];
    }];
}
- (NSArray *)getAllFriends {
    return [RCDDataSource getAllFriends:^{
        [[RCWKNotifier sharedWKNotifier] notifyWatchKitFriendChanged];
    }];
}
- (void)openParentApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"rongcloud://connect"]];
}
- (BOOL)getNewMessageNotificationSound {
    return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
    [RCIM sharedRCIM].disableMessageAlertSound = !on;
}

- (BOOL)getLoginStatus {
    NSString *token = [kDefaults stringForKey:@"userToken"];
    if (token.length) {
        return YES;
    } else {
        return NO;
    }
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Background && 0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
                                                                             ]];
        dispatch_async(dispatch_get_main_queue(),^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        });
    }
}

- (void)application:(UIApplication *)application
handleWatchKitExtensionRequest:(NSDictionary *)userInfo
              reply:(void (^)(NSDictionary *))reply {
    RCWKRequestHandler *handler =
    [[RCWKRequestHandler alloc] initHelperWithUserInfo:userInfo provider:self reply:reply];
    if (![handler handleWatchKitRequest]) {
        // can not handled!
        // app should handle it here
        NSLog(@"not handled the request: %@", userInfo);
    }
}
//设置群组通知消息没有提示音
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message {
    //当应用处于前台运行，收到消息不会有提示音。
    //  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
    return YES;
    //  }
    //  return NO;
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
- (void)removeExpireLogFiles:(NSString *)logPath {
    //删除超过时间的log文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:logPath error:nil]];
    NSDate *currentDate = [NSDate date];
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:LOG_EXPIRE_TIME];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *fileComp = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
    NSMinuteCalendarUnit | NSSecondCalendarUnit;
    fileComp = [calendar components:unitFlags fromDate:currentDate];
    for (NSString *fileName in fileList) {
        // rcMMddHHmmss.log length is 16
        if (fileName.length != 16) {
            continue;
        }
        if (![[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"rc"]) {
            continue;
        }
        int month = [[fileName substringWithRange:NSMakeRange(2, 2)] intValue];
        int date = [[fileName substringWithRange:NSMakeRange(4, 2)] intValue];
        if (month > 0) {
            [fileComp setMonth:month];
        } else {
            continue;
        }
        if (date > 0) {
            [fileComp setDay:date];
        } else {
            continue;
        }
        NSDate *fileDate = [calendar dateFromComponents:fileComp];
        
        if ([fileDate compare:currentDate] == NSOrderedDescending ||
            [fileDate compare:expireDate] == NSOrderedAscending) {
            [fileManager removeItemAtPath:[logPath stringByAppendingPathComponent:fileName] error:nil];
        }
    }
}
- (void)gotoLoginViewAndDisplayReasonInfo:(NSString *)reason {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:reason
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        ;
        [alertView show];
        YSLoginController *loginVC = [[YSLoginController alloc] init];
        BaseNavigationController *_navi = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = _navi;
        
    });
}
#pragma mark -- 发送一个sendReq后，收到微信的回应
- (void)onResp:(BaseResp *)resp {
    //WXSuccess           = 0,    /**< 成功    */
    //WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    //支付返回结果，实际支付结果需要去微信服务器端查询
    //发送媒体消息结果[resp isKindOfClass:[SendMessageToWXResp class]]
    //支付结果[resp isKindOfClass:[PayResp class]]
    //判断是否第三方登录[resp isKindOfClass:[SendAuthResp class]]
    
    // 向微信请求授权后,得到响应结果code
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == 0) {
            SendAuthResp *temp = (SendAuthResp *)resp;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
            NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID_WEIXIN,APPSECRET_WEIXIN,temp.code];
            
            //通过code、appid、secret获取access_token、openid-----------------
            [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"请求access的response = %@", responseObject);
                NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
                NSString *userUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", [accessDict objectForKey:@"access_token"], [accessDict objectForKey:@"openid"]];
                
                //通过access_token、openid获取userInfo----------------
                [manager GET:userUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                    [userInfoDict removeObjectForKey:@"privilege"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEI_XIN_AUTH_SUCCESS object:nil userInfo:userInfoDict];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }else{
            [YTAlertUtil alertSingleWithTitle:@"提示" message:@"授权失败" defaultTitle:@"确定" defaultHandler:nil completion:nil];
        }
    }
    
    // 向微信请求支付后,得到响应结果
    if([resp isKindOfClass:[PayResp class]]) {
//        WXSuccess           = 0,    /**< 成功    */
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        switch (resp.errCode) {
            case WXSuccess:
            {
                //支付成功请求后台接口查询结果
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEI_XIN_PAY_SUCCESS object:nil userInfo:@{@"status":@"success"}];
                break;
            }
            case WXErrCodeUserCancel:
            {
                //用户点击取消并返回
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEI_XIN_PAY_SUCCESS object:nil userInfo:@{@"status":@"failure"}];
                break;
            }
            default:
            {
                //支付失败其他状态
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEI_XIN_PAY_SUCCESS object:nil userInfo:@{@"status":@"failure"}];
                break;
            }
        }
    }
}
- (void)alipayWithURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            9000 订单支付成功
//            8000 正在处理中
//            4000 订单支付失败
//            6001 用户中途取消
//            6002 网络连接出错
            switch ([resultDic[@"resultStatus"]integerValue]) {
                case 9000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALI_PAY_SUCCESS object:nil userInfo:@{@"status":@"success"}];
                    [YTAlertUtil showTempInfo:@"支付成功"];
                    break;
                case 6001:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALI_PAY_SUCCESS object:nil userInfo:@{@"status":@"failure"}];
                    [YTAlertUtil showTempInfo:@"支付失败"];
                    break;
                case 4000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALI_PAY_SUCCESS object:nil userInfo:@{@"status":@"failure"}];
                    [YTAlertUtil showTempInfo:@"支付失败"];
                    break;
                default:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALI_PAY_SUCCESS object:nil userInfo:@{@"status":@"failure"}];
                    [YTAlertUtil showTempInfo:@"支付失败"];
                    break;
            }
        }];
    }
}
//拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message{
    [YTAlertUtil alertSingleWithTitle:@"连程" message:message defaultTitle:@"前往开启" defaultHandler:^(UIAlertAction *action) {
        NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } completion:nil];
}
#pragma mark -------CustomLocationDelegate------
- (void)currentLocation:(NSDictionary *)locationDictionary location:(CLLocation*)location{
    NSLog(@"%@",locationDictionary[@"addRess"]);
    [KUserDefults setObject:locationDictionary[@"city"] forKey:kUserCity];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:kLat];
    [KUserDefults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:KLng];
    [KUserDefults synchronize];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}
@end
