//
//  BidManagerCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"

@class BidManagerCell;

@protocol BidManagerCellDelegate <NSObject>

- (void)bidManagerCell:(BidManagerCell *)view changeBtnClick:(UIButton *)btn;
- (void)bidManagerCell:(BidManagerCell *)view deleteBtnClick:(UIButton *)btn;
- (void)bidManagerCell:(BidManagerCell *)view negotiationBtnClick:(UIButton *)btn;

@end

@interface BidManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bidcountLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *firstStateLab;
@property (weak, nonatomic) IBOutlet UILabel *secondStateLab;
@property (weak, nonatomic) IBOutlet UILabel *thridStateLab;
@property (weak, nonatomic) IBOutlet UILabel *fourStateLab;
@property (weak, nonatomic) IBOutlet UILabel *fiveStateLab;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *thridLab;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UILabel *fiveLab;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *negotiationBtn;
@property (weak, nonatomic) IBOutlet UILabel *reviewStatusLab;
@property (nonatomic, weak) id<BidManagerCellDelegate>delegate;
@property (nonatomic, strong) FirstControllerMo *model;

@end
