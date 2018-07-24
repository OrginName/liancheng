//
//  LCDateMoncePicker.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCDateMoncePicker;

@protocol  LCDateMoncePickerDelegate<NSObject>
- (void)lcDatePickerViewWithPickerView:(LCDateMoncePicker *)picker str:(NSString *)str;

@end

@interface LCDateMoncePicker : UIView
@property (nonatomic, weak) id<LCDateMoncePickerDelegate>delegate;
- (void)animateShow;

@end
