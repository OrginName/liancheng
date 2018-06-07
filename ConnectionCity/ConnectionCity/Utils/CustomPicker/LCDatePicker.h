//
//  LCDatePicker.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCDatePicker;

@protocol  LCDatePickerDelegate<NSObject>
- (void)lcDatePickerViewWithPickerView:(LCDatePicker *)picker str:(NSString *)str;

@end

@interface LCDatePicker : UIView
@property (nonatomic, weak) id<LCDatePickerDelegate>delegate;
- (void)animateShow;

@end
