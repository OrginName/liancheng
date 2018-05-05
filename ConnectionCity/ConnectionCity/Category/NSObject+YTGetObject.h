//
//  NSObject+YTGetObject.h
//  ChargingPile
//
//  Created by chips on 17/6/21.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (YTGetObject)

/** 获取应用程序主窗口 */
- (UIWindow *)yt_getKeyWindow;
/** 获取当前屏幕显示的viewcontroller */
- (UIViewController *)yt_getCurrentVC;

- (UINavigationController *)yt_getRootNC;
- (UINavigationController *)yt_getRootVC;
- (UIViewController *)yt_getNaviLastVC;


@end
