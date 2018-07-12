//
//  NearManCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "NearManCell.h"

@implementation NearManCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMo:(ConnectionMo *)mo{
    _mo = mo;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:mo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_Name.text = mo.nickName;
    self.image_Sex.image = [UIImage imageNamed: [[mo.gender description] isEqualToString:@"1"]?@"men":@"women"];
    self.lab_Distance.text = KString(@"%.2f", [mo.distance floatValue]);
}
@end
