//
//  KissCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "KissCell.h"

@implementation KissCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgImgV.layer.cornerRadius = 5;
    _bgImgV.clipsToBounds = YES;
    _bgImgV.userInteractionEnabled = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(kissCell:deleteBtnClick:)]) {
        [_delegate kissCell:self deleteBtnClick:sender];
    }
}
- (IBAction)sawBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(kissCell:sawBtnClick:)]) {
        [self.delegate kissCell:self sawBtnClick:sender];
    }
}

- (void)setModel:(KissModel *)model {
    _model = model;
    _nameLab.text = [NSString stringWithFormat:@"我为%@开通的亲密账户",model.closeUserId];
    _idLab.text = [NSString stringWithFormat:@"连城号：%@",model.closeUserId];
    _rateLab.text = [NSString stringWithFormat:@"分享比例：%@",model.rate];
    _amountLab.text = [NSString stringWithFormat:@"累计转账：%.2f元",model.incomeAmount];

}

@end
