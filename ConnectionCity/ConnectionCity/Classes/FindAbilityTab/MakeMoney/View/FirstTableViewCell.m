//
//  FirstTableViewCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    _nameLab.text = model.company;
    _moneyLab.text = model.amount;
}
- (IBAction)bidBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(firstTableViewCell:bidBtnClick:)]) {
        [_delegate firstTableViewCell:self bidBtnClick:(UIButton *)sender];
    }
}


@end
