//
//  ShowTrvalCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowTrvalCell.h"

@implementation ShowTrvalCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    NSString * identifiy = @"";
    NSInteger index;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            identifiy = @"ShowTrvalCell0";
            index = 0;
        } else {
            identifiy = @"ShowTrvalCell1";
            index = 1;
        }
    }else if (indexPath.section==1){
        identifiy = @"ShowTrvalCell2";
        index = 2;
    }else{
        identifiy = @"ShowTrvalCell3";
        index = 3;
    }
    ShowTrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:identifiy];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShowTrvalCell" owner:nil options:nil][index];
    }
    return cell;
}
-(void)setList:(ServiceListMo *)list{
    _list = list;
    self.lab_Title.text = list.title;
    if (list.cityName.length!=0) {
        [self.btn_city setTitle:list.cityName forState:UIControlStateNormal];
    }
    [self.btn_height setTitle:list.user1.height?list.user1.height:@"无" forState:UIControlStateNormal];
    [self.btn_coll setTitle:list.user1.educationId?list.user1.educationId:@"无" forState:UIControlStateNormal];
    [self.btn_wight setTitle:list.user1.marriage?list.user1.marriage:@"无" forState:UIControlStateNormal];
    self.lab_Age.text = list.user1.age?list.user1.age:@"无";
    [self.btn_weight setTitle:list.user1.weight?list.user1.weight:@"无" forState:UIControlStateNormal];
    self.lab_ServiceTitle.text = list.content?list.content:@"无";
    self.lab_Des.text = list.introduce?list.introduce:@"无";
    if (list.property.length!=0&&[[self stringToJSON:list.property] count]!=0) {
        self.lab_DW.text =[NSString stringWithFormat:@"擅长位置:%@ 最高段位:%@",[self stringToJSON:list.property][0][@"name"],[self stringToJSON:list.property][1][@"name"]];
    }else
        self.lab_DW.text = @"无";
}
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
- (IBAction)YDClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:sender.tag];
    }
}

@end
