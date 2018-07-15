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
    labArr = @[@"待付款",@"待接单",@"待赴约",@"待完成",@"已履约"];
    labArr1 = @[@"待缴费",@"待接单",@"待赴约",@"服务中",@"服务结束"];
    btnTitleArr = @[@"取消",@"接单",@"赴约",@"终止服务"];
    btnTitleArr1 = @[@"缴费",@"取消",@"履约",@"评价"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellBtnClick:)]) {
        [self.delegate cellBtnClick:self];
    }
}
-(void)setMo:(myServiceMo *)mo{
    _mo = mo;
    self.lab_FWH.text = mo.ID;
    self.lab_orderNo.text = mo.orderNo;
    self.lab_Time.text = mo.serviceTime;
    self.lab_title.text = mo.obj.title?mo.obj.title:@"无";
    self.lab_price.text = [NSString stringWithFormat:@"¥%@%@x%@",mo.obj.price,mo.obj.typeName,mo.num];
    self.lab_sumPrice.text = [NSString stringWithFormat:@"合计:¥%.2f",[mo.obj.price floatValue]*[mo.num intValue]];
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:mo.reserveUser.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = mo.reserveUser.nickName;
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
        if (tableView.tag<1004) {
            [cell.btn_status setTitle:btnTitleArr[tableView.tag-1000] forState:UIControlStateNormal];
        }
    }else{
        if (tableView.tag<1004) {
            [cell.btn_status setTitle:btnTitleArr1[tableView.tag-1000] forState:UIControlStateNormal];
        }
        cell.lab_tipStatus.text = labArr1[tableView.tag-1000];
    }
    return cell;
}
@end
