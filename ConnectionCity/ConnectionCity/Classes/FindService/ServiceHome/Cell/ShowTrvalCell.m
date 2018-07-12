//
//  ShowTrvalCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowTrvalCell.h"
@interface ShowTrvalCell()
{
    NSMutableArray * _arr_image;
}
@end
@implementation ShowTrvalCell
-(void)awakeFromNib{
    [super awakeFromNib];
    _arr_image = [[NSMutableArray alloc] initWithObjects:self.image1,self.image2,self.image3,self.image4, nil];
}
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
-(void)setTrval:(trvalMo *)trval{
    _trval = trval;
    if (trval!=nil) {
        self.lab_ServiceTitle.hidden=YES;
        self.lab_DW.hidden = YES;
        self.lab_PriceDY.hidden = YES;
        self.lab_price.hidden=YES;
        self.lab_Des.hidden = YES;
        self.lab_Title.text = trval.user1.nickName;
        if (trval.cityName.length!=0) {
            [self.btn_city setTitle:trval.cityName forState:UIControlStateNormal];
        }
        [self.btn_height setTitle:[NSString stringWithFormat:@"%@cm",trval.user1.height?trval.user1.height:@"180"] forState:UIControlStateNormal];
        [self.btn_coll setTitle:trval.user1.educationName?trval.user1.educationName:@"无" forState:UIControlStateNormal];
        [self.btn_wight setTitle:trval.user1.marriageName?trval.user1.marriageName:@"无" forState:UIControlStateNormal];
        self.lab_Age.text = trval.user1.age?trval.user1.age:@"无";
        [self.btn_weight setTitle:[NSString stringWithFormat:@"%@kg",trval.user1.weight?trval.user1.weight:@"60"] forState:UIControlStateNormal];
        self.lab_TrvalPrice.text = [NSString stringWithFormat:@"¥%@",trval.price];
        self.lab_TrvalDY.text = trval.priceUnit;//单位暂无
        self.lab_TrvalDes.text = trval.introduce;
        self.lab_LLNum.text = [NSString stringWithFormat:@"浏览%@次",trval.browseTimes?trval.browseTimes:@"999+"];
        self.image_sex.image = [UIImage imageNamed:[KString(@"%@", trval.user1.gender) isEqualToString:@"2"]?@"women":@"men"];
        for (NSDictionary * dic in trval.serviceCircleList) {
            if ([[dic[@"containsImage"] description] isEqualToString:@"1"]) {
                NSArray * arr2 = [dic[@"images"] componentsSeparatedByString:@";"];
                for (int i=0; i<[arr2 count]; i++) {
                    if ([arr2[i] length]!=0) {
                        if (_arr_image.count!=0) {
                            UIImageView * image = _arr_image[i];
                            image.hidden = NO;
                            [image sd_setImageWithURL:[NSURL URLWithString:arr2[i]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
                        }
                    }
                }
                break;
            }
        }
        
    }
//  trval.comments 评论咱不知道怎么写
}
-(void)setList:(ServiceListMo *)list{
    _list = list;
    if (list!=nil) {
        self.lab_TrvalDY.hidden = YES;
        self.lab_TrvalDes.hidden = YES;
        self.lab_TrvalPrice.hidden = YES;
        self.lab_Title.text = list.user1.nickName?list.user1.nickName:@"无";
        if (list.cityName.length!=0) {
            [self.btn_city setTitle:list.cityName forState:UIControlStateNormal];
        }
        [self.btn_height setTitle:list.user1.height?list.user1.height:@"无" forState:UIControlStateNormal];
        [self.btn_coll setTitle:list.user1.educationName?list.user1.educationName:@"无" forState:UIControlStateNormal];
        [self.btn_wight setTitle:list.user1.marriageName?list.user1.marriageName:@"无" forState:UIControlStateNormal];
        self.lab_Age.text = list.user1.age?list.user1.age:@"无";
        self.lab_price.text = [NSString stringWithFormat:@"¥%@",list.price];
        self.lab_PriceDY.text = list.typeName;
        self.image_sex.image = [UIImage imageNamed:[KString(@"%@", list.user1.gender) isEqualToString:@"2"]?@"women":@"men"];
        [self.btn_weight setTitle:list.user1.weight?list.user1.weight:@"无" forState:UIControlStateNormal];
        self.lab_ServiceTitle.text = list.content?list.content:@"无";
        self.lab_Des.text = list.introduce?list.introduce:@"无";
        if (list.property.length!=0&&[[self stringToJSON:list.property] count]!=0) {
            self.lab_DW.text =[NSString stringWithFormat:@"擅长位置:%@ 最高段位:%@",[self stringToJSON:list.property][0][@"name"],[self stringToJSON:list.property][1][@"name"]];
        }else
            self.lab_DW.text = @"无";
        self.lab_LLNum.text = [NSString stringWithFormat:@"浏览%@次",list.browseTimes?list.browseTimes:@"999+"];
        self.lab_DTNum.text = KString(@"%lu", (unsigned long)list.serviceCircleList.count);
        for (NSDictionary * dic in list.serviceCircleList) {
            if ([[dic[@"containsImage"] description] isEqualToString:@"1"]) {
                NSArray * arr2 = [dic[@"images"] componentsSeparatedByString:@";"];
                for (int i=0; i<[arr2 count]; i++) {
                    if ([arr2[i] length]!=0) {
                        if (_arr_image.count!=0) {
                            UIImageView * image = _arr_image[i];
                            image.hidden = NO;
                            [image sd_setImageWithURL:[NSURL URLWithString:arr2[i]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
                        }
                    }
                }
                break;
            }
        }
    }
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
