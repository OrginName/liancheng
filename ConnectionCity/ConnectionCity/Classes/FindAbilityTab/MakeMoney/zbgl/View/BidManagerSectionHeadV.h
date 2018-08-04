//
//  BidManagerSectionHeadV.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"
#import "orderListModel.h"

@interface BidManagerSectionHeadV : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *bidcountLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (nonatomic, strong) FirstControllerMo *model;

@end
