//
//  BulidTeamSectionHead.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BulidTeamSectionHead;
@class YSButton;

@protocol BulidTeamSectionHeadDelegate <NSObject>

- (void)bulidTeamSectionHead:(BulidTeamSectionHead *)bulidTeamSectionHead headerButtonClick:(YSButton *)btn;

@end

@interface BulidTeamSectionHead : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *teamNumbers;
@property (nonatomic, weak) id<BulidTeamSectionHeadDelegate>delegate;

@end
