//
//  BidManagerCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerCell.h"

@implementation BidManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
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

@end
