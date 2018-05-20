//
//  WinningBidderCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WinningBidderCell.h"

@implementation WinningBidderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headerImgView.layer.cornerRadius = 25;
    _headerImgView.clipsToBounds = YES;
    _addFrendBtn.layer.cornerRadius = 3;
    
    // Initialization code
}
- (IBAction)addFrendBtnClick:(id)sender {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
