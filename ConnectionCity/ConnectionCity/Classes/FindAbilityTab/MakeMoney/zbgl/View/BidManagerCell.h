//
//  BidManagerCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BidManagerCell;

@protocol BidManagerCellDelegate <NSObject>

- (void)bidManagerCell:(BidManagerCell *)view changeBtnClick:(UIButton *)btn;
- (void)bidManagerCell:(BidManagerCell *)view deleteBtnClick:(UIButton *)btn;
- (void)bidManagerCell:(BidManagerCell *)view negotiationBtnClick:(UIButton *)btn;

@end

@interface BidManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *negotiationBtn;
@property (nonatomic, weak) id<BidManagerCellDelegate>delegate;

@end
