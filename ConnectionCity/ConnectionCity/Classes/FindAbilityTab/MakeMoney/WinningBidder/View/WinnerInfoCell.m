//
//  WinnerInfoCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WinnerInfoCell.h"

@implementation WinnerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pointLab.layer.cornerRadius = 4;
    _pointLab.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOnemodel:(FirstControllerMo *)onemodel {
    _onemodel = onemodel;
    TenderRecordsMo *tenderMo = [onemodel.tenderRecords firstObject];
    _pointLab.backgroundColor = [UIColor redColor];
    _biderOrWinnerLab.text = @"中标方";
    _biderOrWinnerLab.textColor = [UIColor redColor];
    _peopleLab.text = @"中标人";
    _amountLab.text = @"中标金额";
    _nameLab.text = tenderMo.user.nickName;
    _phoneLab.text = tenderMo.user.mobile;
    _moneyLab.text = tenderMo.amount;
}
- (void)setTwomodel:(FirstControllerMo *)twomodel {
    _twomodel = twomodel;
    _pointLab.backgroundColor = [UIColor orangeColor];
    _biderOrWinnerLab.text = @"招标方";
    _biderOrWinnerLab.textColor = [UIColor orangeColor];
    _peopleLab.text = @"招标人";
    _amountLab.text = @"招标金额";
    _nameLab.text = twomodel.contactName;
    _phoneLab.text = twomodel.contactMobile;
    _moneyLab.text = twomodel.amount;
}

@end
