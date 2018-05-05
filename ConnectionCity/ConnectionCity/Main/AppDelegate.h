//
//  AppDelegate.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/** 应用程序主窗口 */
@property (strong, nonatomic) UIWindow *window;
/** 键盘是否弹出 */
@property (nonatomic, assign, getter=isKeyboardDidShow) BOOL keyboardDidShow;

@end

