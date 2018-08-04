//
//  BidManagerCellOne.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"
#import "orderListModel.h"
@class BidManagerCellOne;

@protocol BidManagerCellOneDelegate <NSObject>

- (void)bidManagerCell:(BidManagerCellOne *)view btn:(UIButton *)btn;

@end

@interface BidManagerCellOne : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (nonatomic, strong) orderListModel *model;
@property (nonatomic, weak) id<BidManagerCellOneDelegate>delegate;

@end
