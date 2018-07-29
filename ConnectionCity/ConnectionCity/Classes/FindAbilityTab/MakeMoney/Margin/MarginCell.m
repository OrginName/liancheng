//
//  MarginCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MarginCell.h"

@implementation MarginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    _titleLab.text = @"保证金";
    _marginMoneyLab.text = model.depositAmount;
}
- (void)setFootModel:(FirstControllerMo *)footModel {
    _footModel = footModel;
    _titleLab.text = @"接单金额";
    _marginMoneyLab.text = footModel.amount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
