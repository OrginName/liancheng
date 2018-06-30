//
//  BidderCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidderCell.h"

@implementation BidderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headerImgView.layer.cornerRadius = 25;
    _headerImgView.clipsToBounds = YES;
    _addFrendBtn.layer.cornerRadius = 3;
    _selectedBtn.layer.cornerRadius = 3;
    
    // Initialization code
}
- (IBAction)addFrendBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidderCell:addFrendBtnClick:)]) {
        [_delegate bidderCell:self addFrendBtnClick:(UIButton *)sender];
    }
}
- (IBAction)selectedBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidderCell:selectedBtnClick:)]) {
        [_delegate bidderCell:self selectedBtnClick:(UIButton *)sender];
    }
}
- (void)setModel:(TenderRecordsMo *)model {
    _model = model;
    privateUserInfoModel *userinfomo = model.user;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:userinfomo.headImage]];
    _nameLab.text = userinfomo.nickName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
