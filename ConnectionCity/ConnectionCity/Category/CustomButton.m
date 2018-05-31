//
//  CustomButton.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomButton.h"
#import "YSConstString.h"
@implementation CustomButton
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.selectBackColor = [UIColor hexColorWithString:@"#f49930"];
        self.NOselectBackColor = [UIColor hexColorWithString:@"#f2f2f2"];
        self.NoSelectTitleColor = [UIColor hexColorWithString:@"#282828"];
        self.selectTitleColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setSelectBackColor:(UIColor *)selectBackColor{
    _selectBackColor = selectBackColor;
}
-(void)setNOselectBackColor:(UIColor *)NOselectBackColor{
    _NOselectBackColor = NOselectBackColor;
}
-(void)setSelectTitleColor:(UIColor *)selectTitleColor{
    _selectTitleColor = selectTitleColor;
}
-(void)setNoSelectTitleColor:(UIColor *)NoSelectTitleColor{
    _NoSelectTitleColor = NoSelectTitleColor;
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self setBackgroundColor:self.selectBackColor];
        [self setTitleColor: self.selectTitleColor forState:UIControlStateNormal];
    }else{
        [self setBackgroundColor:self.NOselectBackColor];
        [self setTitleColor:self.NoSelectTitleColor forState:UIControlStateNormal];
    }
}

@end
