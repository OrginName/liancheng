//
//  FootprintCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FootprintCell.h"

@implementation FootprintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _stateFinishLab.layer.cornerRadius = 10;
    _stateFinishLab.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    
}
@end
