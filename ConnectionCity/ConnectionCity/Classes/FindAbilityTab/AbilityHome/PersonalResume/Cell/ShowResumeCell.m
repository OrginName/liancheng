//
//  ShowResumeCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowResumeCell.h"

@implementation ShowResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (indexPath.section == 1 || indexPath.section == 2) {
        identifier = [NSString stringWithFormat:@"ShowResumeCell%d",2];
        index = 2;
    }else if(indexPath.section==0){
        if (indexPath.row==0){
            identifier = [NSString stringWithFormat:@"ShowResumeCell%d",0];
            index = 0;
        }else if (indexPath.row==2){
            identifier = [NSString stringWithFormat:@"ShowResumeCell%d",1];
            index = 1;
        }else if (indexPath.row==1){
            identifier = @"ShowResumeCell5";
            index = 5;
        }
    }else if(indexPath.section==3){
        identifier = [NSString stringWithFormat:@"ShowResumeCell%d",3];
        index = 3;
    }
    ShowResumeCell *cell = (ShowResumeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowResumeCell" owner:self options:nil] objectAtIndex:index];
        
    }
    cell.lab_ProTitle.text = indexPath.section==2?@"学历：":@"行业：";
    cell.lab_introTitle.text = indexPath.section==2?@"专业：":@"描述：";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)setAbility:(AbilttyMo *)ability{
    _ability = ability;
    self.lab_Name.text = ability.user.nickName;
    self.lab_city.text = ability.user.cityName;
    self.lab_signature.text = ability.user.sign;
    self.image_sex.image = [UIImage imageNamed:[ability.user.gender isEqualToString:@"0"]?@"men":@"women"];
    NSString * str = [NSString stringWithFormat:@"%@/%@",ability.user.occupationCategoryName[@"parentName"],ability.user.occupationCategoryName[@"name"]];
    self.lab_Profession.text = [str containsString:@"null"]?@"":str;
    [self.btn_year setTitle:ability.workingName forState:UIControlStateNormal];//工作经验
    [self.btn_XL setTitle:ability.user.educationName forState:UIControlStateNormal];
    [self.btn_age setTitle:ability.user.age forState:UIControlStateNormal];//年龄
    [self.btn_salary setTitle:ability.salaryName forState:UIControlStateNormal];//薪资名字
    self.txtView_MyselfIntro.text = ability.introduce;
}
-(void)setWork:(AbilttyWorkMo *)work{
    _work = work;
    self.lab_CompanyAndCollege.text = work.companyName;
    self.lab_proW.text = work.occupationCategoryName[@"name"];
    self.lab_MSW.text = work.description1;
    self.lab_time.text = [NSString stringWithFormat:@"%@-%@",work.startDate,work.endDate];
}
-(void)setEdu:(AbilttyEducationMo *)edu{
    _edu = edu; 
    self.lab_CompanyAndCollege.text = edu.schoolName;
    self.lab_proW.text = edu.educationName;
    self.lab_MSW.text = edu.professionalName;
    self.lab_time.text = [NSString stringWithFormat:@"%@-%@",edu.startDate,edu.endDate];
}
@end
