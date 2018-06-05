//
//  OurServiceCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurServiceCell.h"
@interface OurServiceCell()
@property (weak, nonatomic) IBOutlet UIButton *btn_status;
@property (weak, nonatomic) IBOutlet UILabel *lab_tipStatus;
@property (weak, nonatomic) IBOutlet UILabel *lab_evaluation;
@property (weak, nonatomic) IBOutlet UILabel *lab_num;
@end
static NSArray * labArr;
static NSArray * labArr1;
static NSArray * btnTitleArr;
static NSArray * btnTitleArr1;
@implementation OurServiceCell
+(void)initialize{
    labArr = @[@"待付款",@"待接单",@"待赴约",@"待完成",@"已履约"];
    labArr1 = @[@"待缴费",@"待接单",@"待赴约",@"服务中",@"服务结束"];
    btnTitleArr = @[@"",@"",@"",@"",@""];
    btnTitleArr1 = @[@"",@"",@"",@"",@""];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag{
    OurServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OurServiceCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OurServiceCell" owner:nil options:nil][0];
    }
    if (tableView.tag==1004) {
        cell.lab_evaluation.hidden = NO;
        cell.lab_num.hidden = NO;
        cell.btn_status.hidden = YES;
    }else{
        cell.lab_evaluation.hidden = YES;
        cell.lab_num.hidden = YES;
        cell.btn_status.hidden = NO;
    }
    if (tag==1) {
        cell.lab_tipStatus.text = labArr[tableView.tag-1000];
    }else
        cell.lab_tipStatus.text = labArr1[tableView.tag-1000];
    
    return cell;
}
@end
