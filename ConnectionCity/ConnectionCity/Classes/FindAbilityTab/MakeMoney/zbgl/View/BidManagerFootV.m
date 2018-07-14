//
//  BidManagerFootV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerFootV.h"

@implementation BidManagerFootV
- (void)awakeFromNib {
    [super awakeFromNib];
    _firstStateLab.layer.cornerRadius = 10;
    _firstStateLab.clipsToBounds = YES;
    _secondStateLab.layer.cornerRadius = 10;
    _secondStateLab.clipsToBounds = YES;
    _thridStateLab.layer.cornerRadius = 10;
    _thridStateLab.clipsToBounds = YES;
    _fourStateLab.layer.cornerRadius = 10;
    _fourStateLab.clipsToBounds = YES;
    _fiveStateLab.layer.cornerRadius = 10;
    _fiveStateLab.clipsToBounds = YES;
    _fixStateLab.layer.cornerRadius = 10;
    _fixStateLab.clipsToBounds = YES;
    
    // Initialization code
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
