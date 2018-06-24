//
//  EditProfileHeadView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditProfileHeadView;

@protocol EditProfileHeadViewDelegate <NSObject>

- (void)profileHeadView:(EditProfileHeadView *)view photoBtnClick:(UIButton *)btn;
- (void)profileHeadView:(EditProfileHeadView *)view refreshBtnClick:(UIButton *)btn;

@end

@interface EditProfileHeadView : UIView
@property (nonatomic, weak) id<EditProfileHeadViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *headImage;

@end
