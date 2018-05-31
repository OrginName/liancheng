//
//  ShowTrvalCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowTrvalCellDelegate <NSObject>
@optional;
-(void)btnClick:(NSInteger)tag;
@end
@interface ShowTrvalCell : UITableViewCell
@property(nonatomic,assign) id<ShowTrvalCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;
@end
