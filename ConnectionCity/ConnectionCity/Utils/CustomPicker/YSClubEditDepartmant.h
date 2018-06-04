//
//  YSClubEditDepartmant.h
//  dumbbell
//
//  Created by JYS on 17/6/20.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPickerView.h"
@class YSClubEditDepartmant;

@protocol YSClubEditDepartmantDelegate <NSObject>
@optional
- (void)ysClubEditDepartmant:(YSClubEditDepartmant *)ysClubEditDepartmant Str:(NSString *)Str;

@end
@interface YSClubEditDepartmant : UIView <MyPickerViewDelegate>
@property (nonatomic, strong) MyPickerView *bumenPickerView;
@property (nonatomic, strong) UILabel *centerTitleLabel;
@property (nonatomic, strong) NSMutableArray *bumenArr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, weak) id<YSClubEditDepartmantDelegate>delegate;
- (void)animateShow;
@end
