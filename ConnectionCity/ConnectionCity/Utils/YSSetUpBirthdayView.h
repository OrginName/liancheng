//
//  YSSetUpBirthdayView.h
//  dumbbell
//
//  Created by JYS on 17/6/22.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDatePicker.h"
@class YSSetUpBirthdayView;

@protocol YSSetUpBirthdayViewDelegate <NSObject>

- (void)ysSetUpBirthdayView:(YSSetUpBirthdayView *)ysSetUpBirthdayView  Str:(NSString *)Str;

@end

@interface YSSetUpBirthdayView : UIView<MyDatePickerDelegate>
@property (nonatomic, strong) MyDatePicker *datePickerView;
@property (nonatomic, strong) UILabel *centerTitleLabel;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, weak) id<YSSetUpBirthdayViewDelegate>delegate;
- (void)animateShow;

@end
