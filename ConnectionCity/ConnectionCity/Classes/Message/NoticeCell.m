//
//  NoticeCell.m
//  ConnectionCity
//
//  Created by qt on 2018/7/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMo:(NoticeMo *)mo{
    _mo = mo;
    if (![[mo.type description] isEqualToString:@"99"]) {
        self.lab_name.text = mo.user.nickName?mo.user.nickName:mo.user.ID;
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:mo.user.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        self.lab_Title.text = [[mo.title description] containsString:@"null"]?@"":[mo.title description];
    }else{
        self.lab_name.text = [[mo.title description] containsString:@"null"]?@"":[mo.title description];
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:mo.user.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        self.lab_Title.text = [[mo.content description] containsString:@"null"]?@"":[mo.content description];
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreeClik:)]) {
        [self.delegate agreeClik:sender];
    }
}
@end
