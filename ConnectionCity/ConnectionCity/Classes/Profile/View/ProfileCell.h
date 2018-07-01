//
//  ProfileCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OurResumeMo.h"
#import "OurConcernMo.h"

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

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *concernTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *concernTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *concernContentLab;
@property (weak, nonatomic) IBOutlet UILabel *concernPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelConcerBtn;
@property (nonatomic, strong) OurConcernMo *concernModel;

@property (nonatomic,assign) id<profileCellDelegate>delegate;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath currentTag:(NSInteger)tag;

@end
