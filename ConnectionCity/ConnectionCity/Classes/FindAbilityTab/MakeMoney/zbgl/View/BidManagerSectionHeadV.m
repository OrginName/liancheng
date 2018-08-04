//
//  BidManagerSectionHeadV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerSectionHeadV.h"

@implementation BidManagerSectionHeadV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    _titleLab.text = model.title;
    _amountLab.text = model.amount;
    _bidcountLab.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)model.orderList.count];
}
@end
