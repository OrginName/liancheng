//
//  YTAlertUtil.h
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const YTAlertUtilAlertTitleReminder;
FOUNDATION_EXPORT NSString * const YTAlertUtilAlertMessageCancel;
FOUNDATION_EXPORT NSString * const YTAlertUtilAlertMessageReturn;
FOUNDATION_EXPORT NSString * const YTAlertUtilAlertMessageOK;

/** 点击Alert action处理 */
typedef void(^YTAlertUtilAlertHandler)(UIAlertAction *action);
/** 多个类似alert action处理 */
typedef void(^YTAlertUtilMultiAlertHandler)(UIAlertAction *action, NSArray *titles, NSUInteger idx);
/** AlertController显示完成 */
typedef void(^YTAlertUtilAlertCompletion)(void);

/** 封装UIAlertController提示框的工具类 */
@interface YTAlertUtil : NSObject

/** pop单个按钮提示框 */
+ (void)alertSingleWithTitle:(NSString *)title
                     message:(NSString *)message
                defaultTitle:(NSString *)defaultTitle
              defaultHandler:(YTAlertUtilAlertHandler)defaultHandler
                  completion:(YTAlertUtilAlertCompletion)completion;

/** pop两个按钮提示框 */
+ (void)alertDualWithTitle:(NSString *)title
                   message:(NSString *)message
                     style:(UIAlertControllerStyle)preferredStyle
               cancelTitle:(NSString *)cancelTitle
             cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
              defaultTitle:(NSString *)defaultTitle
            defaultHandler:(YTAlertUtilAlertHandler)defaultHandler
                completion:(YTAlertUtilAlertCompletion)completion;

/** pop三个按钮提示框 */
+ (void)alertTripleWithTitle:(NSString *)title
                     message:(NSString *)message
                       style:(UIAlertControllerStyle)preferredStyle
                  firstTitle:(NSString *)firstTitle
                firstHandler:(YTAlertUtilAlertHandler)firstHandler
                 secondTitle:(NSString *)secondTitle
               secondHandler:(YTAlertUtilAlertHandler)secondHandler
                 cancelTitle:(NSString *)cancelTitle
               cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
                  completion:(YTAlertUtilAlertCompletion)completion;

/** pop四个按钮提示框 */
+ (void)alertQuadrupleWithTitle:(NSString *)title
                        message:(NSString *)message
                          style:(UIAlertControllerStyle)preferredStyle
                     firstTitle:(NSString *)firstTitle
                   firstHandler:(YTAlertUtilAlertHandler)firstHandler
                    secondTitle:(NSString *)secondTitle
                  secondHandler:(YTAlertUtilAlertHandler)secondHandler
                     thirdTitle:(NSString *)thirdTitle
                   thirdHandler:(YTAlertUtilAlertHandler)thirdHandler
                    cancelTitle:(NSString *)cancelTitle
                  cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
                     completion:(YTAlertUtilAlertCompletion)completion;

/** pop多个相似按钮提示框 */
+ (void)alertMultiWithTitle:(NSString *)title
                    message:(NSString *)message
                      style:(UIAlertControllerStyle)preferredStyle
                multiTitles:(NSArray<NSString *> *)multiTitles
               multiHandler:(YTAlertUtilMultiAlertHandler)multiHandler
                cancelTitle:(NSString *)cancelTitle
              cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
                 completion:(YTAlertUtilAlertCompletion)completion;

/** pop底部自动消失提示框(有键盘时在中间，没键盘时在底部) */
+ (void)showTempInfo:(NSString *)info;

/** 显示带title的ProgressHUD(在指定view) */
+ (void)showHUDAddedTo:(UIView *)view
                 title:(NSString *)title
              animated:(BOOL)animated;

/** 显示带title的ProgressHUD(在当前窗口上) */
+ (void)showHUDWithTitle:(NSString *)title;

/** 隐藏带title的ProgressHUD(在指定view) */
+ (void)hideHUDForView:(UIView *)view
              animated:(BOOL)animated;

/** 隐藏带title的ProgressHUD(在当前窗口上) */
+ (void)hideHUD;

@end
