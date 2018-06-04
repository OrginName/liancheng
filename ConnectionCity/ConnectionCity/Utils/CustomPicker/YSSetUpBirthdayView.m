//
//  YSSetUpBirthdayView.m
//  dumbbell
//
//  Created by JYS on 17/6/22.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSSetUpBirthdayView.h"

@implementation YSSetUpBirthdayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        //部门选择器
        _datePickerView = [[MyDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _datePickerView.delegate = self;
        [self addSubview:_datePickerView];
        //标题显示
        _centerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 120)/2, 0, 120, 40)];
        _centerTitleLabel.textColor = [UIColor whiteColor];
        _centerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_datePickerView addSubview:_centerTitleLabel];
        
        self.hidden = YES;
        [kWindow addSubview:self];
    }
    return self;
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _centerTitleLabel.text = titleStr;
}
- (void)animateShow {
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:nil];
    [_datePickerView animateShow];
}
- (void)animateHiden {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark - MyDatePickerDelegate
- (void)myDatePickerWithDateStr:(NSString *)dateStr {
    [self animateHiden];
    if (_delegate && [_delegate respondsToSelector:@selector(ysSetUpBirthdayView:Str:)]) {
        [self.delegate ysSetUpBirthdayView:self Str:dateStr];
    }
}
- (void)myPickerViewWithPickerView:(MyDatePicker *)pickerV cancellClick:(UIButton *)btn {
    [self animateHiden];
}
@end
