//
//  PresentCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PresentCell.h"
@interface PresentCell()
@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@end
@implementation PresentCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    NSString * str = @"";
    NSInteger index;
    if (indexPath.section==0&&indexPath.row!=0) {
        str = @"PresentCell1";
        index = 1;
    }else{
        str = @"PresentCell0";
        index = 0;
    }
    PresentCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PresentCell" owner:nil options:nil][index];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.image_Head.image = [UIImage imageNamed:@"weixin"];
            cell.lab_title.text = @"微信";
        }else{
            cell.image_Head.image = [UIImage imageNamed:@"zhi"];
            cell.lab_title.text = @"支付宝";
        }
    }
    return cell;
}
- (void)setModel:(AccountPageMo *)model {
    _model = model;
    _cellNameLab.text = [NSString stringWithFormat:@"%@(%@)",model.accountType,model.accountNumber];
}
- (void)setPaymentModel:(PaymentModel *)paymentModel {
    _paymentModel = paymentModel;
    _paymentTitleLab.text = paymentModel.descriptionModel;
    _paymentTimeLab.text = paymentModel.createTime;
    _paymentMoneyLab.text = paymentModel.amount;
}

@end
