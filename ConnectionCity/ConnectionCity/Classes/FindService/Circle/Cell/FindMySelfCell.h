//
//  FindMySelfCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindMySelfCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_photo;
@property (weak, nonatomic) IBOutlet UILabel *lab_Time;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
