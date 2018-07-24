//
//  LCDateMoncePicker.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "LCDateMoncePicker.h"

@interface LCDateMoncePicker()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LCDateMoncePicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        //创建格式化器
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM"];
        //格式化当前日期
        _dateStr = [_dateFormatter stringFromDate:[NSDate date]];
        //添加子控件
        [self addSubview:self.timeTextField];
        //隐藏
        self.hidden = YES;
        [kWindow addSubview:self];
    }
    return self;
}
- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //        _datePicker.maximumDate = [NSDate date];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        UIToolbar *toolBar = [[UIToolbar alloc]init];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        toolBar.items = @[cancelItem,item,doneItem];
        toolBar.frame = CGRectMake(0, 0, 0, 44);
        _timeTextField = [[UITextField alloc] init];
        _timeTextField.delegate = self;
        _timeTextField.inputView = _datePicker;
        _timeTextField.inputAccessoryView = toolBar;
    }
    return _timeTextField;
}
- (void)animateShow {
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:nil];
    [self.timeTextField becomeFirstResponder];
}
- (void)cancel {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    [self.timeTextField resignFirstResponder];
}
- (void)done {
    [self.timeTextField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(lcDatePickerViewWithPickerView:str:)]) {
        [self.delegate lcDatePickerViewWithPickerView:self str:_dateStr];
    }
}
- (void)dateChange:(UIDatePicker *)datePicker {
    _dateStr = [_dateFormatter  stringFromDate:datePicker.date];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
