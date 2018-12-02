//
//  FJCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FJCell.h"

@implementation FJCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMo:(NearByMo *)mo{
    _mo = mo;
    [self.image_Head sd_setImageWithURL:[NSURL URLWithString:mo.headImage] placeholderImage:[UIImage imageNamed:@"button"]];
    self.lab_Name.text = mo.realName;
    NSString * str = [mo.gender isEqualToString:@"1"]?@"men":@"women";
    self.image_sex.image = [UIImage imageNamed:str];
    self.lab_JL.text = KString(@"%@米", mo.distance);
}
@end
