//
//  AccountManageCell.h
//  ConnectionCity
//
//  Created by qt on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *currentCountLab;
@property (weak, nonatomic) IBOutlet UIButton *image_onLine;
@property (weak, nonatomic) IBOutlet UIImageView *iamge_Select;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
