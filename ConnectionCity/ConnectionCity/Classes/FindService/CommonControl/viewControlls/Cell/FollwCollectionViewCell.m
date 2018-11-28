//
//  FollwCollectionViewCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FollwCollectionViewCell.h"

@implementation FollwCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.view_Bottom.layer.borderColor = YSColor(250, 183, 120).CGColor;
    self.view_Bottom.layer.borderWidth = 2;
     CGFloat itemW = (kScreenWidth - 60)/ 5;
    self.view_Bottom.layer.cornerRadius = (itemW-6)/2;
    self.view_Bottom.layer.masksToBounds = YES;
    
    self.image_Bottom.layer.cornerRadius = (itemW-14)/2;
    self.image_Bottom.layer.masksToBounds = YES;
}

@end
