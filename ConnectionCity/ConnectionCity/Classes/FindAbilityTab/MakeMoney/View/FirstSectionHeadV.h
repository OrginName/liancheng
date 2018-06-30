//
//  FirstSectionHeadV.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstCustomButton.h"

@class FirstSectionHeadV;

@protocol FirstSectionHeadVDelegate <NSObject>

- (void)firstSectionHeadV:(FirstSectionHeadV *)view fbzbBtnClick:(UIButton *)btn;
- (void)firstSectionHeadV:(FirstSectionHeadV *)view zbglBtnClick:(UIButton *)btn;
- (void)firstSectionHeadV:(FirstSectionHeadV *)view cityBtnClick:(UIButton *)btn;
- (void)firstSectionHeadV:(FirstSectionHeadV *)view typeBtnClick:(UIButton *)btn;
- (void)firstSectionHeadV:(FirstSectionHeadV *)view timeBtnClick:(UIButton *)btn;

@end

@interface FirstSectionHeadV : UIView
@property (nonatomic, weak) id<FirstSectionHeadVDelegate>delegate;
@property (weak, nonatomic) IBOutlet FirstCustomButton *cityBtn;
@property (weak, nonatomic) IBOutlet FirstCustomButton *typeBtn;
@property (weak, nonatomic) IBOutlet FirstCustomButton *timeBtn;

@end
