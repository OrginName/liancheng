//
//  TTCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TTCell.h"

@implementation TTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth-20, 50) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = CGRectMake(0, 0, kScreenWidth-20, 50);
    maskLayer.path = maskPath.CGPath;
    self.view_Bottom.layer.mask = maskLayer;
//
    UIBezierPath * maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth-20, 50) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = CGRectMake(0, 0, kScreenWidth-20, 50);
    maskLayer1.path = maskPath1.CGPath;
     self.view_Bottom1.layer.mask = maskLayer1;
}
@end
