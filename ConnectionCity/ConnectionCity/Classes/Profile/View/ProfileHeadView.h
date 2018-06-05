//
//  ProfileHeadView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileHeadView;

@protocol ProfileHeadViewDelegate <NSObject>

- (void)profileHeadView:(ProfileHeadView *)view editBtnClick:(UIButton *)btn;
- (void)profileHeadView:(ProfileHeadView *)view xfBtnClick:(UIButton *)btn;

@end


@interface ProfileHeadView : UIView
@property (nonatomic, weak) id<ProfileHeadViewDelegate>delegate;

@end
