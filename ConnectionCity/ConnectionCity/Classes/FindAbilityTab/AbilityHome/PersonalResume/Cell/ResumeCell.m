//
//  ResumeCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ResumeCell.h"

@implementation ResumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     
}
-(void)setMo:(ResumeMo *)Mo{
    _Mo = Mo;
    self.lab_comAndCollege.text = Mo.collAndcompany;
    self.lab_proAndCollW.text = Mo.proAndPro;
    self.lab_proW.text = Mo.XLAndIntro;
    self.lab_time.text = [NSString stringWithFormat:@"%@-%@",Mo.satrtTime,Mo.endTime];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath withCollArr:(NSMutableArray * )arr withEduArr:(NSMutableArray * )EduArr {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    if (indexPath.section != 4 && indexPath.section != 5) {
        identifier = [NSString stringWithFormat:@"ResumeCell%ld",(long)indexPath.section];
        if (indexPath.section==6) {
            index = 5;
        }else if (indexPath.section==0){
            index = 0;
        } else
        index = 1;
    }else{
        if (indexPath.row==0){
            identifier = [NSString stringWithFormat:@"ResumeCell%d",2];
            index = 2;
        }else if ((indexPath.section==4&&indexPath.row==arr.count+1)||(indexPath.section==5&&indexPath.row==EduArr.count+1)){
            identifier = [NSString stringWithFormat:@"ResumeCell%d",3];
            index = 3;
        }else{
            identifier = [NSString stringWithFormat:@"ResumeCell%d",6];
            index = 6;
        }
    }
    ResumeCell *cell = (ResumeCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ResumeCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.lab_eduAndWork.text  = indexPath.section==5?@"+教育经历":@"+工作经历";
    cell.lab_proOrXL.text = indexPath.section==5?@"学历：":@"职业：";
    cell.lab_pro.text = indexPath.section==5?@"专业：":@"描述：";
    cell.lab_workEdu.text = indexPath.section==5?@"教育经历":@"工作经历";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lab_salaryAndJY.text = indexPath.section == 1?@"薪资":indexPath.section == 2?@"学历":@"工作经验";
    cell.txt_salWay.placeholder = indexPath.section==1?@"请选择薪资":indexPath.section==2?@"学历":@"请选择工作经验";
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
