//
//  WinnerInfoHeadView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WinnerInfoHeadView.h"

@implementation WinnerInfoHeadView
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    _titleLab.text = model.title;
    _companeyAndAddressLab.text = [NSString stringWithFormat:@"%@\n%@",model.company,model.tenderAddress];
    _contentLab.text = model.content;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
