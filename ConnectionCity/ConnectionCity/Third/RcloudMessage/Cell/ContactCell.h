//
//  ContactCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/10/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactCell : UITableViewCell
@property(nonatomic, strong) UIImageView * portraitView;

@property(nonatomic, strong) UILabel * nicknameLabel;

@property(nonatomic, strong) UILabel * userIdLabel;

@property (nonatomic,strong) UILabel * statusLabel;
@end

NS_ASSUME_NONNULL_END
