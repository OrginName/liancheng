//
//  FootprintCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"

@interface FootprintCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateFinishLab;
@property (nonatomic, strong) FirstControllerMo *model;

@end
