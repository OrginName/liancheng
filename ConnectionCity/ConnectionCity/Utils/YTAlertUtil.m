//
//  YTAlertUtil.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTAlertUtil.h"
#import "NSObject+YTGetObject.h"
#import "UIFont+YTInchFit.h"
#import "AppDelegate.h"

#define kAlertContentColor [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.00]

NSString * const YTAlertUtilAlertTitleReminder = @"温馨提示";
NSString * const YTAlertUtilAlertMessageCancel = @"取消";
NSString * const YTAlertUtilAlertMessageReturn = @"返回";
NSString * const YTAlertUtilAlertMessageOK = @"好";

@implementation YTAlertUtil

#pragma mark - UIAlertController
+ (void)alertSingleWithTitle:(NSString *)title
                     message:(NSString *)message
                defaultTitle:(NSString *)defaultTitle
              defaultHandler:(YTAlertUtilAlertHandler)defaultHandler
                  completion:(YTAlertUtilAlertCompletion)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [[self class]p_addActions:nil alertController:alertController cancelTitle:defaultTitle cancelHandler:defaultHandler completion:completion];
}

+ (void)alertDualWithTitle:(NSString *)title
                   message:(NSString *)message
                     style:(UIAlertControllerStyle)preferredStyle
               cancelTitle:(NSString *)cancelTitle
             cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
              defaultTitle:(NSString *)defaultTitle
            defaultHandler:(YTAlertUtilAlertHandler)defaultHandler
                completion:(YTAlertUtilAlertCompletion)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [[self class]p_addActions:[[self class] p_alertActionsWithTitles:@[defaultTitle] handlers:@[defaultHandler]] alertController:alertController cancelTitle:cancelTitle cancelHandler:cancelHandler completion:completion];
}

+ (void)alertTripleWithTitle:(NSString *)title
                     message:(NSString *)message
                       style:(UIAlertControllerStyle)preferredStyle
                  firstTitle:(NSString *)firstTitle
                firstHandler:(YTAlertUtilAlertHandler)firstHandler
                 secondTitle:(NSString *)secondTitle
               secondHandler:(YTAlertUtilAlertHandler)secondHandler
                 cancelTitle:(NSString *)cancelTitle
               cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
                  completion:(YTAlertUtilAlertCompletion)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [[self class]p_addActions:[[self class]p_alertActionsWithTitles:@[firstTitle, secondTitle] handlers:@[firstHandler, secondHandler]] alertController:alertController cancelTitle:cancelTitle cancelHandler:cancelHandler completion:completion];
}

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
                     completion:(YTAlertUtilAlertCompletion)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [[self class]p_addActions:[[self class]p_alertActionsWithTitles:@[firstTitle, secondTitle, thirdTitle] handlers:@[firstHandler, secondHandler, thirdHandler]] alertController:alertController cancelTitle:cancelTitle cancelHandler:cancelHandler completion:completion];
}

+ (void)alertMultiWithTitle:(NSString *)title
                    message:(NSString *)message
                      style:(UIAlertControllerStyle)preferredStyle
                multiTitles:(NSArray<NSString *> *)multiTitles
               multiHandler:(YTAlertUtilMultiAlertHandler)multiHandler
                cancelTitle:(NSString *)cancelTitle
              cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
                 completion:(YTAlertUtilAlertCompletion)completion {
    if (!multiTitles.count) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [[self class]p_addActions:[[self class]p_alertActionsWithTitles:multiTitles multiHandler:multiHandler] alertController:alertController cancelTitle:cancelTitle cancelHandler:cancelHandler completion:completion];
}

#pragma mark - Show message
+ (void)showTempInfo:(NSString *)info {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat bottom = 30;
    if (appDelegate.isKeyboardDidShow) {
        bottom = [UIScreen mainScreen].bounds.size.height*0.5;
    }
    [[self class]p_showTempInfo:info bottomMargin:bottom];
}

#pragma mark - HUD
+ (void)showHUDAddedTo:(UIView *)view
                 title:(NSString *)title
              animated:(BOOL)animated {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (title == nil) {
        title = @"加载中";
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelFont = [UIFont yt_systemFontOfSize:15];
    HUD.labelText = [NSString stringWithFormat:@"%@...", title];
    HUD.removeFromSuperViewOnHide = YES;
}

+ (void)showHUDWithTitle:(NSString *)title {
    [[self class]showHUDAddedTo:nil title:title animated:YES];
}

+ (void)hideHUDForView:(UIView *)view
              animated:(BOOL)animated {
    if (view == nil) {
        view = [self yt_getKeyWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)hideHUD {
    [[self class]hideHUDForView:nil animated:YES];
}

#pragma mark - Private method
+ (UIAlertAction *)p_cancelActionWithTitle:(NSString *)cancelTitle
                             cancelHandler:(YTAlertUtilAlertHandler)cancelHandler {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler ? cancelHandler(action) : nil;
    }];
    return cancelAction;
}

+ (NSArray<UIAlertAction *> *)p_alertActionsWithTitles:(NSArray<NSString *> *)titles
                                              handlers:(NSArray<YTAlertUtilAlertHandler> *)handlers {
    if (titles.count != handlers.count) {
        return nil;
    }
    NSMutableArray<UIAlertAction *> *alertActions = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alerAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handlers[idx] ? handlers[idx](action) : nil;
        }];
        [alertActions addObject:alerAction];
    }];
    return alertActions;
}

+ (NSArray<UIAlertAction *> *)p_alertActionsWithTitles:(NSArray<NSString *> *)titles
                                         multiHandler:(YTAlertUtilMultiAlertHandler)multiHandler {
    NSMutableArray<UIAlertAction *> *alertActions = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alerAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            multiHandler ? multiHandler(action, titles, idx) : nil;
        }];
        [alertActions addObject:alerAction];
    }];
    return alertActions;
}

+ (void)p_addActions:(NSArray <UIAlertAction *> *)actions
     alertController:(UIAlertController *)alertController
         cancelTitle:(NSString *)cancelTitle
       cancelHandler:(YTAlertUtilAlertHandler)cancelHandler
          completion:(YTAlertUtilAlertCompletion)completion {
    [actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertController addAction:action];
    }];
    [alertController addAction:[[self class]p_cancelActionWithTitle:cancelTitle cancelHandler:^(UIAlertAction * _Nonnull action) {
        cancelHandler ? cancelHandler(action) : nil;
    }]];
    [[self yt_getCurrentVC] presentViewController:alertController animated:YES completion:^{
        completion ? completion() : nil;
    }];
}

+ (void)p_showTempInfo:(NSString *)info
          bottomMargin:(CGFloat)bottom {
    if (info.length == 0) {
        return;
    }
    static UILabel *lastLabel;  //记录上次出现的label
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSTimeInterval duration = 1.5;  //alert视图持续时间
    CGFloat spareWidth = AppViewLayoutMargin*4;  //alert视图多余宽度
    CGFloat spareHeight = AppViewLayoutMargin*3;  //alert视图多余高度
    UIColor *backgroundColor = kAlertContentColor;  //alert视图背景颜色
    UIColor *textColor = [UIColor whiteColor];  //alert视图文字颜色
    UIFont *font = [UIFont yt_systemFontOfSize:15];  //alert视图文本字体
    CGSize alertLabelSize = [info boundingRectWithSize:CGSizeMake(screenSize.width*0.8, screenSize.height*0.8) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat alertLabelW = alertLabelSize.width+spareWidth;
    CGFloat alertLabelH = alertLabelSize.height+spareHeight;
    CGFloat alertLabelX = screenSize.width*0.5-alertLabelW*0.5;
    CGFloat alertLabelY = screenSize.height-bottom-alertLabelH;
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertLabelX, alertLabelY, alertLabelW, alertLabelH)];
    alertLabel.backgroundColor = backgroundColor;
    alertLabel.layer.cornerRadius = AppViewCornerRadius*2;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.text = info;
    alertLabel.textColor = textColor;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = font;
    alertLabel.numberOfLines = 0;
    /**
     *  1、添加本次label，移除上次label；
     *  2、时间间隔后移除本次label
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (bottom == screenSize.height * 0.5) {
        alertLabel.center = window.center;
    }
    [window addSubview:alertLabel];
    lastLabel ? [lastLabel removeFromSuperview] : nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        alertLabel ? [alertLabel removeFromSuperview] : nil;
    });
    lastLabel = alertLabel;
}

@end
