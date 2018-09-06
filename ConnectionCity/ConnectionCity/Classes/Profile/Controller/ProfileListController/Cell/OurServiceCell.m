//
//  OurServiceCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurServiceCell.h"
@interface OurServiceCell()
@property (weak, nonatomic) IBOutlet UILabel *lab_orderNo;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_sumPrice;
@property (weak, nonatomic) IBOutlet UILabel *lab_price;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UILabel *lab_Time;
@property (weak, nonatomic) IBOutlet UILabel *lab_FWH;
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
    labArr = @[@"待付款",@"待接单",@"待赴约",@"已赴约",@"待评价",@"已完成"];
    labArr1 = @[@"待缴费",@"待接单",@"待赴约",@"待评价",@"服务结束"];
    btnTitleArr = @[@"取消",@"接单",@"赴约",@"终止服务"];
    btnTitleArr1 = @[@"缴费",@"取消",@"履约",@"评价"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClick:cell:)]) {
        [self.delegate cellBtnClick:sender cell:self];
    }
}
- (IBAction)btn_PL:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cellPLClick:cell:)]) {
        [self.delegate cellPLClick:sender cell:self];
    }
}
-(void)setMo:(myServiceMo *)mo{
    _mo = mo;
    self.lab_FWH.text = mo.orderNo;
    self.lab_orderNo.text = mo.orderNo;
    self.lab_Time.text = mo.serviceTime;
    if ([mo.typeName isEqualToString:@"旅游"]) {
        self.lab_title.text = mo.obj.introduce?mo.obj.introduce:@"无";
    }else{
        self.lab_title.text = mo.obj.serviceCategoryName.name?mo.obj.serviceCategoryName.name:@"-";
    }
    self.lab_price.text = [NSString stringWithFormat:@"¥%@%@x%@",mo.obj.price,[mo.typeName isEqualToString:@"旅游"]?mo.obj.priceUnit:mo.obj.typeName,mo.num];
    self.lab_sumPrice.text = [NSString stringWithFormat:@"合计:¥%.2f",[mo.obj.price floatValue]*[mo.num intValue]];
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:mo.reserveUser.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = mo.reserveUser.nickName;
    NSArray * arr;
    if ([mo.typeName isEqualToString:@"旅游"]) {
        arr = mo.obj.comments;
    }else{
        arr = mo.obj.commentList;
    }
    self.lab_num.text  = KString(@"(%lu)", (unsigned long)[arr count]);
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
    if((tag==2&&tableView.tag==1004)||(tag==1&&tableView.tag==1005)) {
        cell.lab_evaluation.hidden = NO;
        cell.lab_num.hidden = NO;
        cell.btn_status.hidden = YES;
        cell.btn_Cancle.hidden = YES;
        cell.btn_PL.hidden = NO;
    }else{
        cell.lab_evaluation.hidden = YES;
        cell.lab_num.hidden = YES;
        if (tag==2&&tableView.tag==1000) {
            cell.btn_Cancle.hidden = NO;
        }
        if (tag==1&&tableView.tag==1000) {
            cell.btn_status.hidden = YES;
        }else{
           cell.btn_status.hidden = NO;
        }
    }
    if (tag==1) {
        cell.lab_tipStatus.text = labArr[tableView.tag-1000];
        if (tableView.tag<1004) {
            [cell.btn_status setTitle:btnTitleArr[tableView.tag-1000] forState:UIControlStateNormal];
        }else
            cell.btn_status.hidden = YES;
    }else{
        if (tableView.tag<1004) {
            [cell.btn_status setTitle:btnTitleArr1[tableView.tag-1000] forState:UIControlStateNormal];
        }else
            cell.btn_status.hidden = YES;
        cell.lab_tipStatus.text = labArr1[tableView.tag-1000];
    }
    return cell;
}
@end
