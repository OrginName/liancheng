//
//  OrderCell.h
//  ConnectionCity
//
//  Created by qt on 2018/10/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMo.h"
@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_fqNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_taskname;
@property (weak, nonatomic) IBOutlet UILabel *lab_taskMoney;
@property (weak, nonatomic) IBOutlet UILabel *lan_qs;
@property (weak, nonatomic) IBOutlet UILabel *lab_Satus;
@property (weak, nonatomic) IBOutlet UILabel *lab_fqMoney;
@property (weak, nonatomic) IBOutlet UILabel *lab_taskStatus;
@property (nonatomic,strong)OrderMo * mo;
@property (nonatomic,strong)OrderMoFQ * fqMo;
@end
