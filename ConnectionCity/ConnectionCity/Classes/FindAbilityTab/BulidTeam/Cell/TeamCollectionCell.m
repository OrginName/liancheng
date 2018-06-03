//
//  TeamCollectionCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TeamCollectionCell.h"

@implementation TeamCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImgV.layer.cornerRadius = 3;
    _headImgV.clipsToBounds = YES;
    
    // Initialization code
}

@end
