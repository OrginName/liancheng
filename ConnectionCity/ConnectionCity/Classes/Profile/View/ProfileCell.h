//
//  ProfileCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OurResumeMo.h"

@protocol profileCellDelegate <NSObject>
@optional
- (void)selectedItemButton:(NSInteger)index;
@end

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *resumetitleLab;
@property (weak, nonatomic) IBOutlet UILabel *resumeDescribLab;
@property (weak, nonatomic) IBOutlet UILabel *industryAndTimeLab;
@property (nonatomic, strong) OurResumeMo *resumeModel;
@property (nonatomic,assign) id<profileCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag;

@end
