//
//  ResumeCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeMo.h"
typedef void (^blockClick)(void);
@interface ResumeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_Sign;
@property (weak, nonatomic) IBOutlet UILabel *lab_UserCity;
@property (nonatomic,copy)blockClick block;
@property (weak, nonatomic) IBOutlet UILabel *lab_UserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageISNo;
@property (weak, nonatomic) IBOutlet UILabel *lab_workEdu;//工作和教育标题
@property (weak, nonatomic) IBOutlet UILabel *lab_proOrXL;//职业和学历
@property (weak, nonatomic) IBOutlet UILabel *lab_pro;//描述
@property (weak, nonatomic) IBOutlet UILabel *lab_comAndCollege;//大学And公司
@property (weak, nonatomic) IBOutlet UILabel *lab_time;//教育AND职业时间
@property (weak, nonatomic) IBOutlet UILabel *lab_proAndCollW;//大学And公司赋值
@property (weak, nonatomic) IBOutlet UILabel *lab_proW;//描述赋值
@property (weak, nonatomic) IBOutlet UILabel *lab_eduAndWork;//教育AND工作标题
@property (weak, nonatomic) IBOutlet UITextField *txt_salWay;//薪资
@property (weak, nonatomic) IBOutlet UILabel *lab_MyselfProW;//自我介绍
@property (nonatomic,strong)ResumeMo * Mo;
@property (weak, nonatomic) IBOutlet UILabel *lab_salaryAndJY;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath withCollArr:(NSMutableArray * )arr withEduArr:(NSMutableArray * )EduArr;
@end
