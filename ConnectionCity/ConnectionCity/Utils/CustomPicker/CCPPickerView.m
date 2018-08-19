//
//  CCPPickerView.m
//  CCPPickerView
//
//  Created by CCP on 16/7/7.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "CCPPickerView.h"
#define CCPWIDTH [UIScreen mainScreen].bounds.size.width
#define CCPHEIGHT [UIScreen mainScreen].bounds.size.height
#define HIDTH 240
@interface CCPPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
//选择器
@property (nonatomic,strong)UIPickerView *pickerViewLoanMoney;
//toolBar
@property (nonatomic,strong)UIToolbar *toolBarOne;
//组合view
@property (nonatomic,strong) UIView *containerView;
//贷款额度 拼接字符串
@property (copy,nonatomic) NSString *string3;
@property (copy,nonatomic) NSString *string4;
@property (copy,nonatomic) NSString *string5;
@property (copy,nonatomic) NSString *string6;

@property (assign,nonatomic)NSInteger index3;
@property (assign,nonatomic)NSInteger index4;
@property (assign,nonatomic)NSInteger index5;
@property (assign,nonatomic)NSInteger index6;

@property (strong, nonatomic) NSMutableArray *numberArray;
@property (strong, nonatomic) NSMutableArray *numberArray2;


@property (copy,nonatomic)NSString *titleString;
@property (copy,nonatomic)NSString *leftString;
@property (copy,nonatomic)NSString *rightString;

@end

@implementation CCPPickerView

//懒加载控件
- (UIPickerView *)pickerViewLoanMoney {
    
    if (_pickerViewLoanMoney == nil) {
        _pickerViewLoanMoney = [[UIPickerView alloc] init];
        _pickerViewLoanMoney.backgroundColor=[UIColor whiteColor];
        _pickerViewLoanMoney.delegate = self;
        _pickerViewLoanMoney.dataSource = self;
        _pickerViewLoanMoney.frame = CGRectMake(0, 40, CCPWIDTH, HIDTH-40);
    }
    
    return _pickerViewLoanMoney;
}

- (UIToolbar *)toolBarOne {
    
    if (_toolBarOne == nil) {
        
        _toolBarOne = [self setToolbarStyle:self.titleString andCancel:self.leftString andSure:self.rightString];
        }
    
    return _toolBarOne;
}
- (UIView *)containerView {
    
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CCPHEIGHT, CCPWIDTH, HIDTH)];
        [_containerView addSubview:self.toolBarOne];
        [_containerView addSubview:self.pickerViewLoanMoney]; 
    }
    return _containerView;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    self.frame = [UIScreen mainScreen].bounds;
}


- (NSMutableArray *)numberArray2 {
    if (_numberArray2 == nil) {
        _numberArray2 = [NSMutableArray array];
        for (int i = 0; i <=59; i ++) {
            NSString *motnthDate = @"";
            if (i>=0&&i<10) {
                motnthDate = [NSString stringWithFormat:@"0%d",i];
            }else{
                motnthDate = [NSString stringWithFormat:@"%d",i];
            }
            [_numberArray2 addObject:motnthDate];
        }
    }
    return _numberArray2;
}
- (NSMutableArray *)numberArray {
    if (_numberArray == nil) {
        _numberArray = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            NSString *motnthDate = @"";
            if (i>=0&&i<10) {
                motnthDate = [NSString stringWithFormat:@"0%d",i];
            }else{
                motnthDate = [NSString stringWithFormat:@"%d",i];
            }
            [_numberArray addObject:motnthDate];
        }
    }
    return _numberArray;
}

-  (UIToolbar *)setToolbarStyle:(NSString *)titleString andCancel:(NSString *)cancelString andSure:(NSString *)sureString{
    
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, CCPWIDTH, 40);
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CCPWIDTH , 40)];
    lable.backgroundColor = YSColor(244, 177, 113);
    lable.text = titleString;
    lable.textAlignment = 1;
    lable.textColor = [UIColor whiteColor];
    lable.numberOfLines = 1;
    lable.font = [UIFont systemFontOfSize:18];
    [toolbar addSubview:lable];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.frame = CGRectMake(0, 5, 40, 55);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.cornerRadius = 2;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:cancelString forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.backgroundColor = [UIColor clearColor];
    chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseBtn.frame = CGRectMake(10, 5, 40, 55);
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseBtn.layer.cornerRadius = 2;
    chooseBtn.layer.masksToBounds = YES;
    [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseBtn setTitle:sureString forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(doneItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    centerSpace.width = 70;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    
    toolbar.items=@[leftItem,centerSpace,rightItem];
    toolbar.backgroundColor = [UIColor greenColor];

    return toolbar;
}

//点击取消按钮
- (void)remove:(UIButton *) btn { 
    [self dissMissView];
    if (self.clickCancelBtn) {
        self.clickCancelBtn();
    }
    
}

//点击确定按钮
- (void)doneItemClick:(UIButton *) btn {
    NSString * str = [NSString stringWithFormat:@"%@:%@~%@:%@",self.string3,self.string4,self.string5,self.string6];
    if (self.clickSureBtn) {
        self.clickSureBtn(str);
    }
    [self dissMissView];
}
- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.string3 = @"00";
        self.string4 = @"00";
        self.string5 = @"00";
        self.string6 = @"00";
        self.titleString = title;
        self.leftString = cancel;
        self.rightString = sure;
        [self addSubview:self.containerView];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [currentWindows addSubview:self];
        [self tanChu];
    }
    
    return self;
}

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock {
    
    self.clickCancelBtn = cancelBlock;
    
    self.clickSureBtn = sureBlock;
    
}
- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure andClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                                      sureBtClcik:(clickSureBtn)sureBlock {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.string3 = @"00";
        self.string4 = @"00";
        self.string5 = @"00";
        self.string6 = @"00";
        self.titleString = title;
        self.leftString = cancel;
        self.rightString = sure;
        [self addSubview:self.containerView];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [currentWindows addSubview:self];
        self.clickCancelBtn = cancelBlock;
        self.clickSureBtn = sureBlock;
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMissView];
}
- (void)dissMissView{
    
    [UIView animateWithDuration:.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.containerView.frame = CGRectMake(0, CCPHEIGHT, CCPWIDTH, HIDTH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)tanChu{
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(0, CCPHEIGHT-HIDTH, CCPWIDTH, HIDTH);
    } completion:^(BOOL finished) {
    
    }];
}
#pragma pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 7;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0 || component == 4) {
        
        return self.numberArray.count;
        
    } else if (component == 2 || component == 6) {
        
        return self.numberArray2.count;
        
    } else{
        
        return 1;
        
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0: case 4:
            
            return  self.numberArray[row];
            
            break;
            
        case 2: case 6:
            
            return  self.numberArray2[row];
            
            break;
        case 3:
            return  @"~";
            
            break;
            
        default:
            return @":";
    }
    
}


// 选中某一组中的某一行时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0 || component == 4) {
        
        NSString *selStrNum = self.numberArray[row];
        
        switch (component) {
            case 0:
                self.string3 = selStrNum;
                self.index3 = [self.numberArray indexOfObject:selStrNum];
                if (self.index3 < self.index5 ||(self.index3==self.index5&&self.index4 < self.index6)) {
                    
                } else {
                    [self.pickerViewLoanMoney selectRow:row inComponent:4 animated:YES];
                    self.string5 = self.string3;
                    self.index5 = self.index3;
                }
                break;
            case 4:
                self.string5 = selStrNum;
                self.index5 = [self.numberArray indexOfObject:selStrNum];
                if (self.index5 < self.index3) {
                    [self.pickerViewLoanMoney selectRow:self.index3 inComponent:4 animated:YES];
                    self.string5 = self.numberArray[self.index3];
                    self.index5 = self.index3;
                } else {
                    if (self.index4>self.index6) {
                        [self.pickerViewLoanMoney selectRow:self.index4 inComponent:6 animated:YES];
                        self.string6 = self.numberArray[self.index4];
                        self.index6 = self.index4;
                    }
                    self.string5 = self.numberArray[self.index5];
                }
                break;
            default:
                break;
        }
        
    } else {
        
        NSString *selStrNum2 = self.numberArray2[row];
        switch (component) {
            case 2:
                self.string4 = selStrNum2;
                self.index4 = [self.numberArray2 indexOfObject:selStrNum2];
                if (self.index3<self.index5) {
                    
                } else {
                    if (self.index3==self.index5&&self.index4<self.index6) {
                        return;
                    }
                    [self.pickerViewLoanMoney selectRow:row inComponent:6 animated:YES];
                    self.index6 = self.index4;
                    self.string6 = self.string4;
                }
                
                break;
            case 6:
                self.string6 = selStrNum2;
                self.index6 = [self.numberArray2 indexOfObject:selStrNum2];
                if (self.index3==self.index5&&self.index6 < self.index4) {
                    
                    [self.pickerViewLoanMoney selectRow:self.index4 inComponent:6 animated:YES];
                    
                    self.string6 = self.numberArray2[self.index4];
                    
                    self.index6 = self.index4;
                    
                } else {
                    
                    self.string6 = self.numberArray2[self.index6];
                    
                }
                
                break;
            default:
                break;
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
