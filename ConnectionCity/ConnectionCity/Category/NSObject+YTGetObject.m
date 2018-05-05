//
//  NSObject+YTGetObject.m
//  ChargingPile
//
//  Created by chips on 17/6/21.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "NSObject+YTGetObject.h"

@implementation NSObject (YTGetObject)

- (UIWindow *)yt_getKeyWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}

- (UIViewController *)yt_getCurrentVC {
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

- (UINavigationController *)yt_getRootNC {
    /*
    UINavigationController *rootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    YTBaseDrawerController *drawerVC = rootVC.viewControllers[1];
    return (UINavigationController *)drawerVC.centerViewController;
     */
    return nil;
}

- (UIViewController *)yt_getRootVC {
    return [self yt_getRootNC].topViewController;
}

- (UIViewController *)yt_getNaviLastVC {
    return [self yt_getRootNC].viewControllers.lastObject;
}

@end

