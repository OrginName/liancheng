//
//  FirstCustomButton.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstCustomButton.h"

#define kBtnImgWidth 9.5

@implementation FirstCustomButton
//调整button内置label和image的相对位置
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = imageF.origin.x;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF) + 2;
    self.imageView.frame = imageF;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
