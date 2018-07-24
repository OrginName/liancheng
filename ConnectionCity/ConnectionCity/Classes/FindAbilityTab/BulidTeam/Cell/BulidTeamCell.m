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
}
- (IBAction)AppJoin:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(joinIndex:)]) {
        [self.delegate joinIndex:sender];
    }
}
@end
