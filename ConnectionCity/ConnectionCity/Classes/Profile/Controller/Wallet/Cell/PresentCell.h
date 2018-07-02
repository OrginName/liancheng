//
//  PresentCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountPageMo.h"

@interface PresentCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cellNameLab;
@property (weak, nonatomic) IBOutlet UILabel *lab_Settitle;
@property (nonatomic, strong) AccountPageMo *model;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
