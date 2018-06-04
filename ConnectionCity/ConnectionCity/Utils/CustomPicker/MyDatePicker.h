//
//  MyPickerView.h
//  Dumbbell
//
//  Created by JYS on 16/1/25.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDatePickerDelegate;

@interface MyDatePicker : UIView
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, weak) id<MyDatePickerDelegate>delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)animateShow;
@end

@protocol  MyDatePickerDelegate<NSObject>

@required

@optional

- (void)myDatePickerWithDateStr:(NSString *)dateStr;
- (void)myPickerViewWithPickerView:(MyDatePicker *)pickerV cancellClick:(UIButton *)btn;

@end