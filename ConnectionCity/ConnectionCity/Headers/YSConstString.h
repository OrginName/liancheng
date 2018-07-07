//
//  YSConstString.h
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#ifndef YSConstString_h
#define YSConstString_h

#ifdef DEBUG
#define YTLog(...) NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__])
//真机测试显示打印的格式
#define YTRLog(FORMAT, ...) fprintf(stderr, "%s:%d   %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
//真机测试空白打印
#define YTELog YTRLog(@"");

#else
#define YTLog(...)
#define YTRLog(FORMAT, ...)
#define YTELog
#endif
/** 转字符串 */
#define KString(a,b) [NSString stringWithFormat:a,b]
/** RGB颜色 */
#define YSColor(r, g, b)    [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]
/** 通用背景色 */
#define kCommonBGColor      YSColor(239, 239, 239)
/** 主绿色调 */
#define kMainGreenColor    YSColor(34, 217, 99)
//项目字体颜色
#define KFontColor  [UIColor hexColorWithString:@"#282828"]
/** 当前屏幕 */
#define kScreen            [UIScreen mainScreen].bounds
/** 当前屏幕宽度 */
#define kScreenWidth       [UIScreen mainScreen].bounds.size.width
/** 当前屏幕高度 */
#define kScreenHeight      [UIScreen mainScreen].bounds.size.height
/** 获取安全区域 */
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
/** 获取顶部安全区域 */
#define kSafeAreaTopHeight    (kScreenHeight == 812.0 ? 88 : 64)
/** 获取底部安全区域 */
#define kSafeAreaBottomHeight  (kScreenHeight == 812.0 ? 34 : 0)
/** app统一圆角值 */
#define AppViewCornerRadius 5
/** app视图布局边缘 */
#define AppViewLayoutMargin 8
/** app状态栏高度 */
#define AppViewStatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
/** app导航条最大y值 */
#define AppViewNavigationMaxY AppViewCommonHeight + AppViewStatusBarH
/** 视图通用高度 */
#define AppViewCommonHeight 44
/** 循环引用弱化self变量 */
#define WeakSelf __weak typeof(self) weakSelf = self;
/**存储*/
#define KUserDefults [NSUserDefaults standardUserDefaults]
#define KWindowView [[UIApplication sharedApplication].keyWindow.rootViewController view]
/** 主WINDOW */
#define kWindow            [[UIApplication sharedApplication].windows objectAtIndex:0]
/** 获取版本 */
#define kVerison           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** 轻量级数据存储 */
#define kDefaults          [NSUserDefaults standardUserDefaults]
/** 用户登录信息 */
#define kAccount           [YSAccountTool account]
/** 用户个人信息 */
#define kUserinfo          [YSAccountTool userInfo]
/** 是否登录 */
#define kIsLogin           [[GlobalManager globalManagerShare]isOrNoLogin]
/** 响应message */
#define kMessage           @"message"
/** 响应data */
#define kData              @"data"
/** 响应code */
#define kCode              @"code"
/** @"UserCity"*/
#define kUserCity @"UserCity"
#define kUserCityID @"UserCityID"
#define kLat @"lat"
#define KLng @"lng"
#define KAllDic @"kAllDic"
/** 服务的UUID */
#define kServiceUUID              @"FFE0"
/** 通知特征的UUID */
#define kNotifyCharacteristicUUID @"FFE1"
/** 写特征的UUID */
#define kWriteCharacteristicUUID  @"FFE1"
/** 高德地图的key */
#define KGDMapKey @"f007358f38f674546afa00a4b16940ae"
//弹出视图关闭动画
#define CLOSEANI @"CLOSEANI"
/** 请求超时时间 */
static double  const TIME_OUT_INTERVAL = 10;
/** 获取到数据时回调更新特征的value的时候会调用 */
static NSString * const NOTI_UPDATE_VALUE_FOR_CHARACTERISTIC = @"UpdateValueForCharacteristic";
/** 中心管理者连接外设成功 */
static NSString * const NOTI_CONNECT_PERIPHERAL = @"ConnectPeripheral";
/** 中心管理者与外设连接失败或断开连接 */
static NSString * const NOTI_CONNECT_FAIL_OR_DISCONNECT_PERIPHERAL = @"ConnectFailOrDisconnectPeripheral";
/** 监听蓝牙状态 */
static NSString * const NOTI_CENTRAL_MANAGER_DID_UPDATE_STATE = @"CentralManagerDidUpdateState";
/** 发现新外设 */
static NSString * const NOTI_DISCOVER_PERIPHERAL = @"DiscoverPeripheral";
/** 发现外设服务的特征 */
static NSString * const NOTI_DISCOVER_PERIPHERAL_SERVICE_CHARACTERISTIC = @"DiscoverPeripheralServiceCharacteristic";
/** 蓝牙采样率(每秒发送的数据个数) */
static double  const NUM_PER_SEC = 22;

/** 微信授权成功 */
static NSString * const NOTI_WEI_XIN_AUTH_SUCCESS = @"WeiXinAuthSuccess";
/** 微信支付成功 */
static NSString * const NOTI_WEI_XIN_PAY_SUCCESS = @"WeiXinPaySuccess";

#endif /* YSConstString_h */






