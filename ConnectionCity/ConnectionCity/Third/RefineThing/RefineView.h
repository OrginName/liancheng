//
//  TanView.h
//  弹出菜单人数修改
//
//  Created by qt on 16/12/16.
//  Copyright © 2016年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^alertViewSelectedBlock)(NSMutableArray * alertViewData);
@interface RefineView : UIView

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic,strong) UIView * DateView;
@property (nonatomic, copy) alertViewSelectedBlock block;
//弹出视图展示的方法
- (instancetype)initWithFrame:(CGRect)frame type:(UIView *)type;
- (void)alertSelectViewshow;
- (void)alertSelectViewClose;
//从右往左弹出
- (void)alertSelectViewshowLeft;
@end
