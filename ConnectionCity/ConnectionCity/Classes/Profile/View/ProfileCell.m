//
//  ProfileCell.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell
- (void)awakeFromNib {
    [super awakeFromNib];
    if (_resumeModel) {
        self.resumeModel = _resumeModel;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag{
    NSString * str = [NSString stringWithFormat:@"ProfileCell%ld",tag];
    ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][tag];
    }
    return cell;
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedItemButton:index:)]) {
        [_delegate selectedItemButton:(UIButton *)sender index:sender.tag];
    }
}
- (IBAction)resumeeditBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedItemButton:index:)]) {
        [_delegate selectedItemButton:(UIButton *)sender index:1];
    }
}
- (IBAction)resumeedeleteBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedItemButton:index:)]) {
        [_delegate selectedItemButton:(UIButton *)sender index:2];
    }
}

- (void)setResumeModel:(OurResumeMo *)resumeModel {
    _resumeModel = resumeModel;
    self.resumetitleLab.text = resumeModel.introduce;
    self.resumeDescribLab.text = resumeModel.cityName;
    self.industryAndTimeLab.text = resumeModel.createTime;
}
- (void)setConcernModel:(OurConcernMo *)concernModel {
    _concernModel = concernModel;
    _concernTitleLab.text = concernModel.typeName;
    _concernTimeLab.text = concernModel.createTime;
    _concernContentLab.text = concernModel.typeName;
}

- (void)setServiceModel:(ServiceMo *)serviceModel{
    _serviceModel = serviceModel;
    _serviceTitleLab.text = serviceModel.title;
    _servicepriceLab.text = [NSString stringWithFormat:@"￥%@%@",serviceModel.price,serviceModel.typeName];
    _serviceContentLab.text = [NSString stringWithFormat:@"￥%@/%@",serviceModel.serviceCategoryName.parentName,serviceModel.serviceCategoryName.name];
    _serviceTimeLab.text = serviceModel.createTime;
}
- (void)setTourismModel:(tourismMo *)tourismModel {
    _tourismModel = tourismModel;
    _tourismTitleLab.text = tourismModel.introduce;
    _tourismPriceLab.text = [NSString stringWithFormat:@"￥%@%@",tourismModel.price,tourismModel.priceUnit];
    _tourismAddressLab.text = tourismModel.cityName;
    _tourismTimeLab.text = tourismModel.createTime;
}
- (void)setTravelInviteModel:(TravelInvite *)travelInviteModel{
    _travelInviteModel = travelInviteModel;
    _travelInviteTitleLab.text = travelInviteModel.placeTravel;
    _travelInviteObjectLab.text = travelInviteModel.inviteObjectName;
    _travelInviteTimeLab.text = travelInviteModel.startTime;
}
@end
