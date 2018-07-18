//
//  RCDAddressBookTableViewCell.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendMo.h"
@protocol RCDAddressBookCellDelegate <NSObject>
@optional
- (void)acceptClick:(UIButton *)btn;
@end
@interface RCDAddressBookTableViewCell : UITableViewCell
@property (nonatomic,assign) id<RCDAddressBookCellDelegate>delegate;
/**
 *  cell高度
 *
 */
+ (CGFloat)cellHeight;

/**
 *  设置模型
 *
 *  @param user 设置用户信息模型，填充控件的数据
 */
- (void)setModel:(friendMo *)user;

/**
 *  昵称
 */
@property(nonatomic, strong) UILabel *nameLabel;

/**
 *  头像
 */
@property(nonatomic, strong) UIImageView *portraitImageView;

/**
 *  “已接受”、“已邀请”
 */
@property(nonatomic, strong) UILabel *rightLabel;

/**
 *  右箭头
 */
@property(nonatomic, strong) UIImageView *arrow;

/**
 *  “接受”按钮
 */
@property(nonatomic, strong) UIButton *acceptBtn;

@end
