//
//  KissCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KissModel.h"

@class KissCell;

@protocol KissCellDelegate <NSObject>
- (void)kissCell:(KissCell *)cell deleteBtnClick:(UIButton *)btn;
- (void)kissCell:(KissCell *)cell sawBtnClick:(UIButton *)btn;

@end

@interface KissCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (nonatomic,weak)id<KissCellDelegate>delegate;
@property (nonatomic, strong) KissModel *model;

@end
