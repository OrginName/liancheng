//
//  BidderCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenderRecordsMo.h"
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"

@class BidderCell;

@protocol UITableViewCellDelegate <NSObject>
- (void)bidderCell:(BidderCell *)cell addFrendBtnClick:(UIButton *)btn;
- (void)bidderCell:(BidderCell *)cell selectedBtnClick:(UIButton *)btn;

@end

@interface BidderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *addFrendBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (nonatomic, weak) id<UITableViewCellDelegate>delegate;
@property (nonatomic, strong) TenderRecordsMo *model;

@end
