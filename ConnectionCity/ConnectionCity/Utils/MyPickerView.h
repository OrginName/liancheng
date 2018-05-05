//
//  MyPickerView.h
//  Dumbbell
//
//  Created by JYS on 16/1/26.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPickerViewDelegate;

@interface MyPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSString *pickerViewStr;
@property (nonatomic, strong) NSMutableArray *mutableArr;
@property (nonatomic, weak) id<MyPickerViewDelegate>delegate;
@property (nonatomic, assign) NSInteger selectedRow;
- (void)animateShow;

@end

@protocol MyPickerViewDelegate <NSObject>

@required

@optional

- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV Str:(NSString *)Str;
- (void)myPickerViewWithPickerView:(MyPickerView *)pickerV cancellClick:(UIButton *)btn;
@end