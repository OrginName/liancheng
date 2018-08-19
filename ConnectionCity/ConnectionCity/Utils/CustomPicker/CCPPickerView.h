//
//  CCPPickerView.h
//  CCPPickerView
//
//  Created by CCP on 16/7/7.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCancelBtn)(void);

typedef void(^clickSureBtn)(NSString *timeStr);

@interface CCPPickerView : UIView

@property (copy,nonatomic) void(^clickCancelBtn)(void);
@property (copy,nonatomic) void (^clickSureBtn)(NSString *timeStr);

- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure;

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock;


@end
