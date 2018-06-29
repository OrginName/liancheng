//
//  FindMySelfCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
@interface FindMySelfCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_photo;
@property (weak, nonatomic) IBOutlet UILabel *lab_Time;
@property (nonatomic,strong) Moment * moment;
@property (weak, nonatomic) IBOutlet UILabel *lab_Month;
@property (weak, nonatomic) IBOutlet UILabel *lab_date;
@property (weak, nonatomic) IBOutlet UILabel *lab_city;
@property (weak, nonatomic) IBOutlet UILabel *lab_content;
@property (weak, nonatomic) IBOutlet UIImageView *image_first;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
