//
//  ProfileCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btn_Click:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectedItemButton:)]) {
        [self.delegate selectedItemButton:sender.tag];
    }
}

@end
