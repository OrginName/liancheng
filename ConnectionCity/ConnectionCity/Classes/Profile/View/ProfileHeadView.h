//
//  ProfileHeadView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "privateUserInfoModel.h"
#import "OccupationCategoryNameModel.h"

@class ProfileHeadView;

@protocol ProfileHeadViewDelegate <NSObject>

- (void)profileHeadView:(ProfileHeadView *)view editBtnClick:(UIButton *)btn;
- (void)profileHeadView:(ProfileHeadView *)view xfBtnClick:(UIButton *)btn;
- (void)profileHeadViewHeadImgTap:(ProfileHeadView *)view;
- (void)profileHeadViewHeadImgLongTap:(ProfileHeadView *)view;

@end


@interface ProfileHeadView : UIView
@property (nonatomic, weak) id<ProfileHeadViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *genderName;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UIButton *svipLogoBtn;
@property (weak, nonatomic) IBOutlet UILabel *svipTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *svipxfBtn;
@property (weak, nonatomic) IBOutlet UIImageView *twoBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *twoNickName;
@property (weak, nonatomic) IBOutlet UILabel *twoSvipTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *twoSvipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *threebackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *threeheadImage;
@property (weak, nonatomic) IBOutlet UILabel *threenickName;
@property (weak, nonatomic) IBOutlet UILabel *threesvipTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *threesvipImgV;
@property (weak, nonatomic) IBOutlet UIButton *threeembershipRenewalBtn;

@property (copy, nonatomic) void (^Block)(void);

@end
