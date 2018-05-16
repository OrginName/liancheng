//
//  ShowResumeCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowResumeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_introTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_ProTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_city;
@property (weak, nonatomic) IBOutlet UILabel *lab_signature;
@property (weak, nonatomic) IBOutlet UILabel *lab_Profession;
@property (weak, nonatomic) IBOutlet UIButton *btn_salary;
@property (weak, nonatomic) IBOutlet UIButton *btn_year;
@property (weak, nonatomic) IBOutlet UIButton *btn_XL;
@property (weak, nonatomic) IBOutlet UIButton *btn_age;
@property (weak, nonatomic) IBOutlet UILabel *lab_CompanyAndCollege;
@property (weak, nonatomic) IBOutlet UILabel *lab_proW;//职业
@property (weak, nonatomic) IBOutlet UILabel *lab_MSW;//描述
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UILabel *lab_EduAndWork;//工作或教育经历标题
@property (weak, nonatomic) IBOutlet UITextView *txtView_MyselfIntro;//上下翻转的图片

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Scroll;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
