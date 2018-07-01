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
- (IBAction)expandBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(biddInfoHeadView:expandBtnClick:)]) {
        [_delegate biddInfoHeadView:self expandBtnClick:(UIButton *)sender];
    }
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"展开"]) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        _contentLab.numberOfLines = 0;
        CGSize contentSize = [_model.content boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        self.height = 230 + 50 + contentSize.height + 20 + 110;
    }else{
        [btn setTitle:@"展开" forState:UIControlStateNormal];
        _contentLab.numberOfLines = 1;
        self.height = 230 + 50 + 15 + 20 + 110;
    }
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    privateUserInfoModel *userinfomo = model.user;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:userinfomo.headImage]];
    _nameLab.text = userinfomo.nickName;
    _industryLab.text = model.industryCategoryName;
    _titleLab.text = model.title;
    _companeyAndAddressLab.text = [NSString stringWithFormat:@"%@\n%@",model.company,model.tenderAddress];
    _contentLab.text = model.content;
    self.height = 230 + 50 + 15 + 20 + 110;
}
@end















