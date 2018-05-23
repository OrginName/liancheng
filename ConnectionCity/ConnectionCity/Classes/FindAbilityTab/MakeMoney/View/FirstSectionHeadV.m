//
//  FirstSectionHeadV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstSectionHeadV.h"

@implementation FirstSectionHeadV
- (void)layoutSubviews {
    self.frame = CGRectMake(0, 0, kScreenWidth, 100);
}
- (IBAction)fbzbBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstSectionHeadV:fbzbBtnClick:)]) {
        [_delegate firstSectionHeadV:self fbzbBtnClick:(UIButton *)sender];
    }
}
- (IBAction)zbglBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstSectionHeadV:zbglBtnClick:)]) {
        [_delegate firstSectionHeadV:self zbglBtnClick:(UIButton *)sender];
    }
}
- (IBAction)cityBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstSectionHeadV:cityBtnClick:)]) {
        [_delegate firstSectionHeadV:self cityBtnClick:(UIButton *)sender];
    }
}
- (IBAction)typeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstSectionHeadV:typeBtnClick:)]) {
        [_delegate firstSectionHeadV:self typeBtnClick:(UIButton *)sender];
    }
}
- (IBAction)timeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstSectionHeadV:timeBtnClick:)]) {
        [_delegate firstSectionHeadV:self timeBtnClick:(UIButton *)sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
