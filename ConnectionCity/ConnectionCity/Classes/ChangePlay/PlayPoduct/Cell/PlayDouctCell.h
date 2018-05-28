//
//  PlayDouctCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayDouctCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UIButton *btn_SelectChange;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath withCollArr:(NSMutableArray * )arr;
@end
