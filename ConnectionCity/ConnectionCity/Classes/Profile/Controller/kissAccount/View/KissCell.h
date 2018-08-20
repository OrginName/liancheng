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
@optional
- (void)kissCell:(KissCell *)cell deleteBtnClick:(UIButton *)btn;
@optional
- (void)kissCell:(KissCell *)cell sawBtnClick:(UIButton *)btn;

@end

@interface KissCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_background;
@property (nonatomic,strong) NSString * flagStr;
@property (nonatomic,strong) NSDictionary * dicReceive;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (nonatomic,assign)id<KissCellDelegate>delegate;
@property (nonatomic, strong) KissModel *model;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name2;//20人为我开头亲密账户
@property (weak, nonatomic) IBOutlet UILabel *lab_SYLJ;//累计收益
@property (weak, nonatomic) IBOutlet UIImageView *image_bottom2;

@end
