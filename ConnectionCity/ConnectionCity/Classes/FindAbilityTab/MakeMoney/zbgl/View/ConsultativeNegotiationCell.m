//
//  ConsultativeNegotiationCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ConsultativeNegotiationCell.h"

@implementation ConsultativeNegotiationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(InstallmentMo *)model{
    _model = model;
    self.selectedBtn.selected = model.bbb;
    self.titleLab.text = model.title;
    self.dataTF.text = model.data;
}
- (IBAction)selectedBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(consultativeNegotiationCell:selectedBtn:)]) {
        [_delegate consultativeNegotiationCell:self selectedBtn:(UIButton *)sender];
    }
}

@end
