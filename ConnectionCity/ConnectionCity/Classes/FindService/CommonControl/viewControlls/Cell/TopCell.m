//
//  TopCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = YSColor(232, 233, 234).CGColor;
    self.layer.shadowOffset = CGSizeMake(5, 5);
    self.layer.shadowOpacity = .5;
    self.layer.shadowRadius = 10;
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.image_head.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.image_head.bounds;
    maskLayer.path = maskPath.CGPath;
    self.image_head.layer.mask = maskLayer;
    
    UIBezierPath * maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.lab_Name.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer * maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.lab_Name.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.lab_Name.layer.mask = maskLayer1;

}
@end
