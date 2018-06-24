//
//  ProfileHeadView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileHeadView.h"

@implementation ProfileHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.model = _model;
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
}

#pragma mark - 点击事件
- (IBAction)editBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadView:editBtnClick:)]) {
        [_delegate profileHeadView:self editBtnClick:(UIButton *)sender];
    }
}
- (IBAction)membershipRenewalBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadView:xfBtnClick:)]) {
        [_delegate profileHeadView:self xfBtnClick:(UIButton *)sender];
    }
}

- (void)setModel:(privateUserInfoModel *)model{
    _model = model;
    [self.twoBackgroundImage sd_setImageWithURL:[NSURL URLWithString:model.backgroundImage] placeholderImage:[UIImage imageNamed:@"1"]];
    [self.twoHeadImage sd_setImageWithURL:[NSURL URLWithString:model.headImage]];
    self.twoNickName.text = model.realName;
    self.twoSvipTimeLab.text = @"xxxx.xx.xx";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
