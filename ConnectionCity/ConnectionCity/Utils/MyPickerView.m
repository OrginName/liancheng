//
//  MyPickerView.m
//  Dumbbell
//
//  Created by JYS on 16/1/26.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "MyPickerView.h"

@interface MyPickerView ()

@property (strong, nonatomic)UIPickerView *pickerView;

@end

@implementation MyPickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化默认字符串
        self.pickerViewStr = @"";
        //创建选择器背景View
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        myView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self addSubview:myView];
        //创建取消、确定背景View
        UIView *quxiaoquedingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        quxiaoquedingView.backgroundColor = kMainGreenColor;
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
        determineBtn.frame = CGRectMake(kScreenWidth - 50, 0, 50, 40);
        determineBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
        [quxiaoquedingView addSubview:determineBtn];
        //创建选择器
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 160)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [myView addSubview:_pickerView];
    }
    return self;
}
#pragma mark picker 按钮点击方法
- (void)cancellClick:(UIButton *)btn {
    __weak MyPickerView *weakSelf = self;
    CGRect rect = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = rect;
    }completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(myPickerViewWithPickerView:cancellClick:)]) {
        [_delegate myPickerViewWithPickerView:self cancellClick:btn];
    }
}
- (void)determineClick:(UIButton *)btn {
    __weak MyPickerView *weakSelf = self;
    CGRect rect = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = rect;
    }completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(myPickerViewWithPickerView:Str:)]) {
        [self.delegate myPickerViewWithPickerView:self Str:_pickerViewStr];
    }
}
- (void)setMutableArr:(NSMutableArray *)mutableArr {
    _mutableArr = mutableArr;
    [_pickerView reloadAllComponents];
}
#pragma mark picker 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _mutableArr.count;
}
#pragma mark picker 代理方法
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
#pragma mark ---
-(void)setSelectedRow:(NSInteger)selectedRow {
    _selectedRow = selectedRow;
    _pickerViewStr = _mutableArr[selectedRow];
    [_pickerView selectRow:selectedRow  inComponent:0 animated:NO];
}
- (void)animateShow {
    self.hidden = NO;
    __weak MyPickerView *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
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
