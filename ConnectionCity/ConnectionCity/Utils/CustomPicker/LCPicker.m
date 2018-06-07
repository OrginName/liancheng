//
//  LCPicker.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "LCPicker.h"

@interface LCPicker()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *pickerViewStr;

@end
@implementation LCPicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        //初始化默认字符串
        self.pickerViewStr = @"";
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
        //创建选择器
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
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
- (void)setMutableArr:(NSMutableArray *)mutableArr {
    _mutableArr = mutableArr;
    [_pickerView reloadAllComponents];
    if (_mutableArr.count == 0) {
        _pickerViewStr = @"";
    }else{
        _pickerViewStr = _mutableArr[0];
    }
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
    if (_delegate && [_delegate respondsToSelector:@selector(lcPickerViewWithPickerView:str:)]) {
        [self.delegate lcPickerViewWithPickerView:self str:_pickerViewStr];
    }
}
#pragma mark picker delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _mutableArr.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (_mutableArr.count == 0) {
        return @"";
    }else{
        return _mutableArr[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (_mutableArr.count == 0) {
        _pickerViewStr = @"";
    }else{
        _pickerViewStr = _mutableArr[row];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
