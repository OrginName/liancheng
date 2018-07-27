//
//  RCDAddressBookTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDAddressBookTableViewCell.h"
#import "DefaultPortraitView.h"
#import "RCDCommonDefine.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#define CellHeight 65.0f

@implementation RCDAddressBookTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat cellWidth = self.frame.size.width;
    CGFloat cellHeight = CellHeight;
    CGFloat screenWidth = RCDscreenWidth;
    if (cellWidth < screenWidth) {
        cellWidth = screenWidth;
    }
    //头像 portraitImageView
    CGFloat portraitImageViewX = 6 + 16;
    CGFloat portraitImageViewY = cellHeight / 2.0 - 36 / 2.0;
    self.portraitImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(portraitImageViewX, portraitImageViewY, 36, 36)];

    //昵称
    CGFloat nameLabelWidth = 200;
    CGFloat nameLabelHeight = 21;
    CGFloat nameLabelX = CGRectGetMaxX(self.portraitImageView.frame) + 8;
    CGFloat nameLabelY = portraitImageViewY-5;
    self.nameLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    
    //昵称
    CGFloat desLabelX = nameLabelX;
    CGFloat desLabelY = nameLabelY+26;
    self.desLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(desLabelX, desLabelY, nameLabelWidth, nameLabelHeight)];
    self.desLabel.textColor = [UIColor lightGrayColor];
    self.desLabel.font = [UIFont systemFontOfSize:13];
    

//    //右侧箭头
//    CGFloat arrowWidth = 15;
//    CGFloat arrowHeight = cellHeight - 19.5 - 19 - 8 - 8;
//    CGFloat arrowX = cellWidth - arrowWidth - 8;
//    CGFloat arrowY = cellHeight / 2.0 - arrowHeight / 2.0;
//    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
//    self.arrow.image = [UIImage imageNamed:@"grayarrow"];

    //“接受”按钮
    _acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 20, 80, 30)];
    _acceptBtn.tag = self.tag;
    [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
    [_acceptBtn setTintColor:[UIColor whiteColor]];
    _acceptBtn.layer.cornerRadius = 5;
    [_acceptBtn setBackgroundColor:[UIColor orangeColor]];
    _acceptBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_acceptBtn.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [_acceptBtn addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.portraitImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:_acceptBtn];
    [self.contentView addSubview:self.desLabel];
}
-(void)accept:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(acceptClick:)]) {
        [self.delegate acceptClick:btn];
    }
}
- (void)setModel:(friendMo *)user {
    if (user) {
        self.nameLabel.text = user.user.nickName?user.user.nickName:user.user.ID;
        self.desLabel.text = user.des;
        if ([user.user.headImage isEqualToString:@""]) {
            DefaultPortraitView *defaultPortrait =
                [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [defaultPortrait setColorAndLabel:user.friendId Nickname:user.user.nickName];
            UIImage *portrait = [defaultPortrait imageFromView];
            self.portraitImageView.image = portrait;
        } else {
            [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:user.user.headImage]
                                      placeholderImage:[UIImage imageNamed:@"contact"]];
        }
    }
    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE &&
        [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
        self.portraitImageView.layer.masksToBounds = YES;
        self.portraitImageView.layer.cornerRadius = 18.f;
    } else {
        self.portraitImageView.layer.masksToBounds = YES;
        self.portraitImageView.layer.cornerRadius = 5.f;
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return CellHeight;
}

@end
