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
    
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
    _twoHeadImage.layer.cornerRadius = 27;
    _twoHeadImage.clipsToBounds = YES;
    UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgTap)];
    [self.headImage addGestureRecognizer:headImgTap];
    
    UILongPressGestureRecognizer *headImageLongTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(headImageLongTap)];
    [self.headImage addGestureRecognizer:headImageLongTap];
    
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
- (void)headImgTap {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadViewHeadImgTap:)]) {
        [_delegate profileHeadViewHeadImgTap:self];
    }
}
- (void)headImageLongTap {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadViewHeadImgLongTap:)]) {
        [_delegate profileHeadViewHeadImgLongTap:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
