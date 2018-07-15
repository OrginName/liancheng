//
//  BidManagerCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerCell.h"
#import "BidStateTools.h"

@implementation BidManagerCell

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
    _changeBtn.layer.cornerRadius = 3;
    _changeBtn.layer.borderWidth = 1;
    _changeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _deleteBtn.layer.cornerRadius = 3;
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _negotiationBtn.layer.cornerRadius = 3;
    _negotiationBtn.layer.borderWidth = 1;
    _negotiationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidManagerCell:changeBtnClick:)]) {
        [_delegate bidManagerCell:self changeBtnClick:(UIButton *)sender];
    }
}
- (IBAction)deleteBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidManagerCell:deleteBtnClick:)]) {
        [_delegate bidManagerCell:self deleteBtnClick:(UIButton *)sender];
    }
}
- (IBAction)negotiationBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidManagerCell:negotiationBtnClick:)]) {
        [_delegate bidManagerCell:self negotiationBtnClick:(UIButton *)sender];
    }
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    _titleLab.text = model.title;
    _amountLab.text = model.amount;
    _firstLab.text = model.periodAmount1;
    _secondLab.text = model.periodAmount2;
    _thridLab.text = model.periodAmount3;
    _fourLab.text = model.periodAmount4;
    _fiveLab.text = model.periodAmount5;
    _firstStateLab.text = [BidStateTools stateStrWithState:[model.payStatus1 integerValue]];
    _secondStateLab.text = [BidStateTools stateStrWithState:[model.payStatus2 integerValue]];
    _thridStateLab.text = [BidStateTools stateStrWithState:[model.payStatus3 integerValue]];
    _fourStateLab.text = [BidStateTools stateStrWithState:[model.payStatus4 integerValue]];
    _fiveStateLab.text = [BidStateTools stateStrWithState:[model.payStatus5 integerValue]];
}

@end
