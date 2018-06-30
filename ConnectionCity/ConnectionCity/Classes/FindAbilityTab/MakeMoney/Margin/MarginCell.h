//
//  MarginCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"

@interface MarginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *marginMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) FirstControllerMo *model;

@end
