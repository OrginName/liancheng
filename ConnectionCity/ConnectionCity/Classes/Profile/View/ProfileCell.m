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
    if ([self.delegate respondsToSelector:@selector(selectedItemButton:)]) {
        [self.delegate selectedItemButton:sender.tag];
    }
}
- (IBAction)resumeeditBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resumeeditBtn:)]) {
        [self.delegate resumeeditBtn:sender];
    }
}
- (IBAction)resumeedeleteBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resumeedeleteBtn:)]) {
        [self.delegate resumeedeleteBtn:sender];
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

@end
