//
//  QFDatePickerView.m
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "QFDatePickerView.h"
#import "AppDelegate.h"

@interface QFDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    
    BOOL onlySelectYear;
}

@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation QFDatePickerView

#pragma mark - initDatePickerView
/**
 初始化方法，只带年月的日期选择
 
 @param block 返回选中的日期
 @return QFDatePickerView对象
 */
- (instancetype)initDatePackerWithResponse:(void (^)(NSString *))block{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    if (block) {
        backBlock = block;
    }
    onlySelectYear = NO;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    //添加子控件
    [self addSubview:self.timeTextField];
    //隐藏
    self.hidden = YES;
    [kWindow addSubview:self];
    
    return self;
}

/**
 初始化方法，只带年份的日期选择
 
 @param block 返回选中的年份
 @return QFDatePickerView对象
 */
- (instancetype)initYearPickerViewWithResponse:(void(^)(NSString*))block {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    if (block) {
        backBlock = block;
    }
    onlySelectYear = YES;
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    //添加子控件
    [self addSubview:self.timeTextField];
    //隐藏
    self.hidden = YES;
    [kWindow addSubview:self];
    
    return self;
}

#pragma mark - Configuration
- (UITextField *)timeTextField {
    if (!_timeTextField) {
        [self getCurrentDate];
        
        [self setYearArray];
        
        [self setMonthArray];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
        
        //设置pickerView默认选中当前时间
        [_pickerView selectRow:[selectedYear integerValue] - 1970 inComponent:0 animated:YES];
        if (!onlySelectYear) {
            [_pickerView selectRow:[selectecMonth integerValue] - 1 inComponent:1 animated:YES];
        }
        
        UIToolbar *toolBar = [[UIToolbar alloc]init];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        toolBar.items = @[cancelItem,item,doneItem];
        toolBar.frame = CGRectMake(0, 0, 0, 44);
        _timeTextField = [[UITextField alloc] init];
        _timeTextField.delegate = self;
        _timeTextField.inputView = _pickerView;
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
    if (onlySelectYear) {
        restr = [selectedYear stringByReplacingOccurrencesOfString:@"年" withString:@""];
    } else {
        if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
            restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
        } else {
            restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
        }
        
        restr = [restr stringByReplacingOccurrencesOfString:@"年" withString:@""];
        restr = [restr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    }
    backBlock([NSString stringWithFormat:@"%ld-%.2ld",(long)[selectedYear integerValue],(long)[selectecMonth integerValue]]);
}
- (void)getCurrentDate {
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
}

- (void)setYearArray {
    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1970; i <= currentYear ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)i];
        [yearArray addObject:yearStr];
    }
//    [yearArray addObject:@"至今"];
}

- (void)setMonthArray {
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
    
    if ([[selectedYear substringWithRange:NSMakeRange(0, 4)] isEqualToString:[NSString stringWithFormat:@"%ld",currentYear]]) {
        for (NSInteger i = 1 ; i <= currentMonth; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
            [monthArray addObject:monthStr];
        }
    } else {
        for (NSInteger i = 1 ; i <= 12; i++) {
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)i];
            [monthArray addObject:monthStr];
        }
    }
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if (onlySelectYear) {
            restr = [selectedYear stringByReplacingOccurrencesOfString:@"年" withString:@""];
        } else {
            if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
                restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
            } else {
                restr = [NSString stringWithFormat:@"%@-%@",selectedYear,selectecMonth];
            }
            
            restr = [restr stringByReplacingOccurrencesOfString:@"年" withString:@""];
            restr = [restr stringByReplacingOccurrencesOfString:@"月" withString:@""];
        }
        backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (onlySelectYear) {//只选择年
        return 1;
    } else {
        return 2;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray.count;
    } else {
        if (component == 0) {
            return yearArray.count;
        } else {
            return monthArray.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        return yearArray[row];
    } else {
        if (component == 0) {
            return yearArray[row];
        } else {
            return monthArray[row];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (onlySelectYear) {//只选择年
        selectedYear = yearArray[row];
    } else {
        if (component == 0) {
            selectedYear = yearArray[row];
            if ([selectedYear isEqualToString:@"至今"]) {//至今的情况下,月份清空
                [monthArray removeAllObjects];
                selectecMonth = @"";
            } else {//非至今的情况下,显示月份
                [self setMonthArray];
                selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
            }
            [pickerView reloadComponent:1];
            
        } else {
            selectecMonth = monthArray[row];
        }
    }
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

@end
