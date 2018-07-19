//
//  CircleCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CircleCell.h"

@implementation CircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMoment:(Comment *)moment{
    _moment = moment;
    [self.image_Head sd_setImageWithURL:[NSURL URLWithString:moment.user.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = moment.user.nickName?moment.user.nickName:moment.user.ID;
    self.lab_Content.text = moment.content;
    self.lab_time.text = [moment.createTime componentsSeparatedByString:@" "][0];
    self.lab_HF.text = moment.replyList.count!=0?moment.replyList[0][@"content"]:@"";
    moment.cellHeight = 45+[YSTools cauculateHeightOfText:self.lab_Content.text width:(self.width-60) font:14]+[YSTools cauculateHeightOfText:self.lab_HF.text width:(self.width-80) font:14];
}
-(void)setMo:(ObjComment *)mo{
    _mo = mo;
    [self.image_Head sd_setImageWithURL:[NSURL URLWithString:mo.user.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = mo.user.nickName?mo.user.nickName:mo.user.ID;
    self.lab_Content.text = mo.content;
    self.lab_time.text = [mo.createTime componentsSeparatedByString:@" "][0];
    self.lab_HF.text = mo.replyList.count!=0?mo.replyList[0][@"content"]:@"";
    mo.cellHeight = 45+[YSTools cauculateHeightOfText:self.lab_Content.text width:(self.width-60) font:14]+[YSTools cauculateHeightOfText:self.lab_HF.text width:(self.width-80) font:14];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
@end
