//
//  EditProfileHeadView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditProfileHeadView.h"

@implementation EditProfileHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
}
- (IBAction)photoBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadView:photoBtnClick:)]) {
        [_delegate profileHeadView:self photoBtnClick:(UIButton *)sender];
    }
}
- (IBAction)refreshBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(profileHeadView:refreshBtnClick:)]) {
        [_delegate profileHeadView:self refreshBtnClick:(UIButton *)sender];
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
