//
//  MyPickerView.m
//  Dumbbell
//
//  Created by JYS on 16/1/25.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "MyDatePicker.h"
@interface MyDatePicker()

@property (nonatomic,strong)UIView * blackView;
@end
@implementation MyDatePicker
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //创建格式化器
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //格式化当前日期
        _dateStr = [_dateFormatter stringFromDate:[NSDate date]];
        //创建选择器背景View
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
        myView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self addSubview:myView];
        //创建取消、确定背景View
        UIView *quxiaoquedingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, myView.width, 40)];
        quxiaoquedingView.backgroundColor = [UIColor hexColorWithString:@"#f49930"];
        [myView addSubview:quxiaoquedingView];
        //创建取消按钮
        UIButton *cancellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancellBtn.frame = CGRectMake(0, 0, 50, 40);
        cancellBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancellBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancellBtn addTarget:self action:@selector(cancellClick:) forControlEvents:UIControlEventTouchUpInside];
        [quxiaoquedingView addSubview:cancellBtn];
        //创建确定按钮
        UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        determineBtn.frame = CGRectMake(myView.width - 50, 0, 50, 40);
        determineBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
        [quxiaoquedingView addSubview:determineBtn];
        //创建日期选择器
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, myView.width, 160)];
        datePicker.date = [NSDate date];
        /*
        //设置日期选择器的最大最小日期
        NSDate *minDate = [NSDate dateWithTimeIntervalSinceNow:-31536000];
        datePicker.minimumDate = minDate;
        NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:31536000];
        datePicker.maximumDate = maxDate;
         */
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [myView addSubview:datePicker];
    }
    return self;
}
#pragma mark -
#pragma mark picker 按钮点击方法
- (void)cancellClick:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(myPickerViewWithPickerView:cancellClick:)]) {
        [self.delegate myPickerViewWithPickerView:self cancellClick:btn];
    }
    __weak MyDatePicker *weakSelf = self;
    CGRect rect = CGRectMake(0, kScreenHeight, self.width,self.height);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = rect;
    }];
}
- (void)determineClick:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(myDatePickerWithDateStr:)]) {
        [self.delegate myDatePickerWithDateStr:_dateStr];
    }
    __weak MyDatePicker *weakSelf = self;
    CGRect rect = CGRectMake(0, kScreenHeight, self.width, self.height);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = rect;
    }];
}
- (void)dateChanged:(UIDatePicker *)datePicker {
    _dateStr = [_dateFormatter stringFromDate:datePicker.date];
}
#pragma mark ---
- (void)animateShow {
    self.hidden = NO;
    __weak MyDatePicker *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = CGRectMake(0, kScreenHeight - self.height, self.width, self.height);
    } completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
