//
//  BiddInfoHeadView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BiddInfoHeadView.h"

@implementation BiddInfoHeadView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgV.layer.cornerRadius = 25;
    self.headImgV.clipsToBounds = YES;
    
    // Initialization code
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    privateUserInfoModel *userinfomo = model.user;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:userinfomo.headImage]];
    _nameLab.text = userinfomo.nickName;
    _industryLab.text = model.industryCategoryName;
    _titleLab.text = model.title;
    _companeyAndAddressLab.text = [NSString stringWithFormat:@"%@\n%@",model.company,model.tenderAddress];
    _contentLab.text = model.content;
}
@end















