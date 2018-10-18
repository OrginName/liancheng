//
//  OrderCell.m
//  ConnectionCity
//
//  Created by qt on 2018/10/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMo:(OrderMo *)mo{
    _mo = mo;
    if (mo.fq.count==0) {
        self.lab_fqNum.hidden = YES;
    }else
        self.lab_fqNum.text = KString(@"(%lu)", (unsigned long)mo.fq.count);
    self.lab_taskname.text = mo.title;
    self.lab_taskMoney.text = KString(@"%@元", mo.amount);
    self.lab_taskStatus.text = [mo.status isEqualToString:@"4"]?@"结束":@"中单";
}
-(void)setFqMo:(OrderMoFQ *)fqMo{
    _fqMo = fqMo;
    NSInteger a = [fqMo.FQstatus integerValue];
    self.lan_qs.text = fqMo.name;
    self.lab_Satus.text = a==60?@"完成":a==10?@"待付款":a==20?@"已支付":a==30?@"代交付":a==40?@"交付确认中":@"";
    self.lab_fqMoney.text = KString(@"%@元", fqMo.amount);
}
@end
