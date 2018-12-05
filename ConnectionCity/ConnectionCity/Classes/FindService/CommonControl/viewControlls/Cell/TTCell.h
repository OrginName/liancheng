//
//  TTCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceMo.h"
typedef void (^btnClickTT) (void);
@interface TTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lab_name1;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UIImageView *imag2;
@property (weak, nonatomic) IBOutlet UILabel *lab_name2;
@property (weak, nonatomic) IBOutlet UILabel *lab_tip1;
@property (weak, nonatomic) IBOutlet UILabel *lab_tipi2;
@property (weak, nonatomic) IBOutlet UIImageView *imag3;
@property (weak, nonatomic) IBOutlet UILabel *lab_tip5;
@property (nonatomic,strong)TTMo * mo;
@property (nonatomic,copy)btnClickTT block;
@end
