//
//  BulidTeamCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BulidTeamCell.h"

@implementation BulidTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImgeView.layer.cornerRadius = 35.0/2.0;
    self.headerImgeView.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
