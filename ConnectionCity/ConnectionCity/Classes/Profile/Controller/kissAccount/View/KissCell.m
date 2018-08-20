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
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    if ([self.flagStr isEqualToString:@"MEVIEW"]) {
        _nameLab.text = [NSString stringWithFormat:@"%@为我开通的亲密账户",model.closeUserId];
    }else
    _nameLab.text = [NSString stringWithFormat:@"我为%@开通的亲密账户",model.closeUserId];
    _idLab.text = [NSString stringWithFormat:@"连城号：%@",model.closeUserId];
    _rateLab.text = [NSString stringWithFormat:@"分享比例：%.0f%%",[model.rate floatValue]*100];
    _amountLab.text = [NSString stringWithFormat:@"累计转账：%.2f元",model.incomeAmount];
    self.image_background.image = self.image_bottom2.image = [UIImage imageNamed:KString(@"bg%u", arc4random()%4)];
    
}

@end
