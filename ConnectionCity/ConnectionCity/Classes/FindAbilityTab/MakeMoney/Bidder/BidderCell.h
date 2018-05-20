//
//  BidderCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *addFrendBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
