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
    if ([YSTools dx_isNullOrNilWithObject:moment.user[@"headImage"]]) {
        self.image_Head.image = [UIImage imageNamed:@"no-pic"];
    }else{
        [self.image_Head sd_setImageWithURL:[NSURL URLWithString:moment.user[@"headImage"]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    }
    self.lab_name.text = [YSTools dx_isNullOrNilWithObject:moment.user[@"nickName"]]?moment.userMo.ID:moment.user[@"nickName"];
    self.lab_Content.text = moment.content;
    self.lab_time.text = [moment.createTime componentsSeparatedByString:@" "][0];
    self.lab_HF.text = @"未知回复";
}
@end
