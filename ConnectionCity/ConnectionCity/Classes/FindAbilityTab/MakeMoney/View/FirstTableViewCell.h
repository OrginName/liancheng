//
//  FirstTableViewCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstTableViewCell;

@protocol FirstTableViewCellDelegate <NSObject>

- (void)firstTableViewCell:(FirstTableViewCell *)firstTableViewCell  bidBtnClick:(UIButton *)btn;

@end

@interface FirstTableViewCell : UITableViewCell
@property (nonatomic, weak) id<FirstTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *bidBtn;

@end
