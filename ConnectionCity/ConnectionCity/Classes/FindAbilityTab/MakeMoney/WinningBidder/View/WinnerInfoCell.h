//
//  WinnerInfoCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"
#import "TenderRecordsMo.h"

@interface WinnerInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *biderOrWinnerLab;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (nonatomic, strong) FirstControllerMo *twomodel;
@property (nonatomic, strong) FirstControllerMo *onemodel;

@end
