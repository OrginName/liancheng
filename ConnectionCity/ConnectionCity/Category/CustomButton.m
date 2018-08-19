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
        self.NoSelectBorderColor = [UIColor whiteColor];
        self.SelectborderColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
    }
    return self;
}
-(void)setNoSelectBorderColor:(UIColor *)NoSelectBorderColor{
    _NoSelectBorderColor = NoSelectBorderColor;
    self.layer.borderColor = NoSelectBorderColor.CGColor;
}
-(void)setSelectborderColor:(UIColor *)SelectborderColor{
    _SelectborderColor = SelectborderColor;
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
-(void)setSelectborderWidth:(NSInteger)SelectborderWidth{
    _SelectborderWidth = SelectborderWidth;
    self.layer.borderWidth = SelectborderWidth;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:self.selectBackColor];
        [self setTitleColor: self.selectTitleColor forState:UIControlStateNormal];
        self.layer.borderColor = self.SelectborderColor.CGColor;
    }else{
        [self setBackgroundColor:self.NOselectBackColor];
        [self setTitleColor:self.NoSelectTitleColor forState:UIControlStateNormal];
        self.layer.borderColor = self.NoSelectBorderColor.CGColor;
    }
}
@end
