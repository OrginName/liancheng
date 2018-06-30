//
//  FirstTableViewCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"

@class FirstTableViewCell;

@protocol FirstTableViewCellDelegate <NSObject>

- (void)firstTableViewCell:(FirstTableViewCell *)firstTableViewCell  bidBtnClick:(UIButton *)btn;

@end

@interface FirstTableViewCell : UITableViewCell
@property (nonatomic, strong) FirstControllerMo *model;
@property (nonatomic, weak) id<FirstTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *bidBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *binderOrWinnerLab;
@property (weak, nonatomic) IBOutlet UIImageView *binderOrWinnerImgV;

@end
