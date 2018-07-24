//
//  BulidTeamCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BulidTeamCellDelegate <NSObject>//协议
@optional
- (void)joinIndex:(UIButton *)index;//协议方法
@end
@interface BulidTeamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumbersLab;
@property (weak, nonatomic) IBOutlet UIButton *btnJoin;
@property (nonatomic,assign) id<BulidTeamCellDelegate> delegate;
@end
