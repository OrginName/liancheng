//
//  YSClubEditDepartmant.m
//  dumbbell
//
//  Created by JYS on 17/6/20.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSClubEditDepartmant.h"

@implementation YSClubEditDepartmant
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        //日期选择器
        _bumenPickerView = [[MyPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
        _bumenPickerView.delegate = self;
        [self addSubview:_bumenPickerView];
        _bumenPickerView.selectedRow = 0;        
        //标题显示
        _centerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 120)/2, 0, 120, 40)];
        _centerTitleLabel.textColor = [UIColor whiteColor];
        _centerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_bumenPickerView addSubview:_centerTitleLabel];

        self.hidden = YES;
        [kWindow addSubview:self];
    }
    return self;
}
- (void)setBumenArr:(NSMutableArray *)bumenArr {
    _bumenArr = bumenArr;
    _bumenPickerView.mutableArr = _bumenArr;
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
    [_bumenPickerView animateShow];
}
- (void)animateHiden {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark - MyPickerViewDelegate
- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV Str:(NSString *)Str {
    [self animateHiden];
    if (_delegate && [_delegate respondsToSelector:@selector(ysClubEditDepartmant:Str:)]) {
        [self.delegate ysClubEditDepartmant:self Str:Str];
    }
}
- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV cancellClick:(UIButton *)btn {
    [self animateHiden];
}

@end
