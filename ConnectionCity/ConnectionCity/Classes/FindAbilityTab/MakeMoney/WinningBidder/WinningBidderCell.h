//
//  WinningBidderCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenderRecordsMo.h"
#import "privateUserInfoModel.h"
@class WinningBidderCell;

@protocol WinningBidderCellDelegate <NSObject>
- (void)winnerCell:(WinningBidderCell *)cell addFrendBtnClick:(UIButton *)btn;

@end

@interface WinningBidderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *addFrendBtn;
@property (nonatomic, weak) id<WinningBidderCellDelegate>delegate;
@property (nonatomic, strong) TenderRecordsMo *model;

@end
