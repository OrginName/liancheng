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
    
    UIBezierPath * maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth-20, 50) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = CGRectMake(0, 0, kScreenWidth-20, 50);
    maskLayer1.path = maskPath1.CGPath;
     self.view_Bottom1.layer.mask = maskLayer1;
}
-(void)setMo:(TTMo *)mo{
    _mo = mo;
    NSString * time = [mo.createTime componentsSeparatedByString:@" "][0];
    if ([YSTools dx_isNullOrNilWithObject:time]) {
        time = @"-";
    }
    if ([mo.type isEqualToString:@"10"]) {
        self.lab_name1.text = mo.nickName;
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
        self.lab_time.text =time;
        self.lab_name2.text = mo.providerNickName;
        [self.imag2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.providerHeadImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
        self.lab_tip1.text = @"预约了";
        self.lab_tipi2.text = @"服务";
    }else{
         [self.imag3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
        self.lab_tip5.text = [NSString stringWithFormat:@"%@在%@%@",mo.nickName,time,mo.title];
    }
}
- (IBAction)Send:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
@end
