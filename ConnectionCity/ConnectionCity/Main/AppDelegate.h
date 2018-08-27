//
//  AppDelegate.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOneTabController.h"
#import "CustomLocatiom.h"

/** 网络是否连接 */
typedef NS_ENUM(NSUInteger, AppDelegateNetworkStatus) {
    AppDelegateNetworkStatusDisconnect = 0,    //网络未连接
    AppDelegateNetworkStatusConnected          //网络已连接
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/** 应用程序主窗口 */
@property (strong, nonatomic) UIWindow *window;
/** 键盘是否弹出 */
@property (nonatomic, assign, getter=isKeyboardDidShow) BOOL keyboardDidShow;
/** 网络连接状态 */
@property(nonatomic, assign) AppDelegateNetworkStatus networkStatus;
@property (nonatomic,strong) CustomLocatiom * location;
@end

