//
//  OtherView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kissAccountController.h"
@class OtherView;
@protocol OtherViewDelegate <NSObject>
- (void)otherView:(OtherView *)view addBtn:(UIButton *)btn;

@end

@interface OtherView : UIView
@property (nonatomic, strong) NSString *refreshStr;
@property (nonatomic, weak) id<OtherViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame viewController:(kissAccountController *)controller;
- (void)getHeaderData;//刷新数据
@end
