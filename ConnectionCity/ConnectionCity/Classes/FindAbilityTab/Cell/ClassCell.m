//
//  ClassCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell

- (void)awakeFromNib {
    [super awakeFromNib]; 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.view_top.backgroundColor = [UIColor orangeColor];
        self.backgroundColor = YSColor(242, 242, 242);
    }else{
        self.view_top.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
