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
//    if (list.property.length!=0&&[[YSTools stringToJSON:list.property] count]!=0) {
//        NSString * propertyTxt = @"";
//        NSArray * arr = [YSTools stringToJSON:list.property];
//        for (NSDictionary * dic in arr) {
//            NSString * str = @"";
//            NSArray * arr1 = dic[@"childs"];
//            for (NSDictionary * dic1 in arr1) {
//                if (str.length==0) {
//                    str = dic1[@"name"];
//                }else
//                    str = [NSString stringWithFormat:@"%@,%@",dic1[@"name"],str];
//            }
//            propertyTxt = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@:%@",dic[@"name"],str],propertyTxt];
//        }
//        self.lab_des.text =propertyTxt;
//    }else
//        self.lab_des.text = @"无";
    if ([YSTools dx_isNullOrNilWithObject:list.serviceCategoryName]) {
        self.lab_des.text = @"无";
    }else
    self.lab_des.text = [NSString stringWithFormat:@"%@/%@",list.serviceCategoryName[@"parentName"],list.serviceCategoryName[@"name"]];
}
@end
