//
//  TrvalCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalCell.h"
@interface TrvalCell()
@property (weak, nonatomic) IBOutlet UILabel *lab_title;

@end
static NSArray * arr_title;
@implementation TrvalCell
+(void)initialize{
    [super initialize];
    arr_title = @[@"旅行去哪",@"邀约对象",@"出发时间",@"旅行时长",@"出行方式",@"旅行花费"];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString * str = @"";
    NSInteger a = 0;
    if (indexPath.section!=2) {
        str = @"TrvalCell2";
        a=2;
    }else{
        str = @"TrvalCell3";
        a=3;
    }
    TrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][a];
        if (indexPath.section==0) {
            cell.lab_title.text = arr_title[indexPath.row];
        }else if (indexPath.section==1){
            cell.lab_title.text = arr_title[indexPath.row+2];
        } 
        
    }
    return cell;
}
-(void)setReceive_Mo:(trvalMo *)receive_Mo{
    _receive_Mo = receive_Mo;
    [self.image_Head sd_setImageWithURL:[NSURL URLWithString:receive_Mo.user.headImage] placeholderImage:[UIImage imageNamed:@"logo2"]];
    self.lab_Name.text = receive_Mo.user.nickName?receive_Mo.user.nickName:@"无";
    self.lab_Time.text = receive_Mo.createTime;
    self.lab_Age.text = receive_Mo.user.age?receive_Mo.user.age:@"无";
    self.image_Sex.image = [UIImage imageNamed:[receive_Mo.user.gender isEqualToString:@"0"]?@"men":@"women"];
    self.lab_TrvalPlace.text = receive_Mo.cityName?receive_Mo.cityName:@"";
    self.lab_Trvaltime.text = receive_Mo.longTimeName?receive_Mo.longTimeName:@"";
    self.lab_DX.text = receive_Mo.inviteObjectName?receive_Mo.inviteObjectName:@"";
    self.lab_TrvalGoTime.text = receive_Mo.departTimeName?receive_Mo.departTimeName:@"";
    self.lab_TrvalWay.text = receive_Mo.travelModeName?receive_Mo.travelModeName:@"";
    self.lab_Money.text = receive_Mo.travelFeeName?receive_Mo.travelFeeName:@"";
    self.lab_SM.text = receive_Mo.description1?receive_Mo.description1:@"";
}
- (IBAction)DetailPerson:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(DetailClick:)]) {
        [self.delegate DetailClick:sender];
    }
}
- (IBAction)sendMessage:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(btnSend:)]) {
        [self.delegate btnSend:sender];
    }
}
@end
