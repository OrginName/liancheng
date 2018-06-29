//
//  ServiceListCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceListCell.h"

@implementation ServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setList:(ServiceListMo *)list{
    _list = list;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:list.user1.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = list.title;
    if (list.property.length!=0&&[[YSTools stringToJSON:list.property] count]!=0) {
        self.lab_des.text =[NSString stringWithFormat:@"擅长位置:%@ 最高段位:%@",[YSTools stringToJSON:list.property][0][@"name"],[YSTools stringToJSON:list.property][1][@"name"]];
    }else
        self.lab_des.text = @"无";
}
@end
