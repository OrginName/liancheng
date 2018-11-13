//
//  NewsListCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setYlMo:(YLMo *)ylMo{
    _ylMo = ylMo;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:ylMo.user.headImage] placeholderImage:[UIImage imageNamed:@"logo2"]];
    if ([ylMo.images containsString:@";"]) {
        ylMo.images = [ylMo.images componentsSeparatedByString:@";"][0];
    }
    [self.iamge_yl sd_setImageWithURL:[NSURL URLWithString:ylMo.images] placeholderImage:[UIImage imageNamed:@"2"]];
    self.lab_title.text = ylMo.user.nickName ? ylMo.user.nickName:ylMo.ID;
    self.lab_context.text = ylMo.introduce;
}
@end
