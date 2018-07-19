//
//  TanView.m
//  弹出菜单人数修改
//
//  Created by qt on 16/12/16.
//  Copyright © 2016年 qt. All rights reserved.
//

#import "RefineView.h"
#import "UIView+YSCategory.h"
#import "YSConstString.h"

#define TANWIDTH CGRectGetHeight(self.DateView.frame)
#define TANHIDTH CGRectGetWidth(self.DateView.frame)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface RefineView()

@end

@implementation RefineView
- (instancetype)initWithFrame:(CGRect)frame type:(UIView *)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.3;
        [self addSubview:self.blackView];
        self.DateView = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertSelectViewClose) name:CLOSEANI object:nil];
//
    }
    return self;
}
//-(void)layoutSubviews{
//    self.blackView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    self.bgView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, TANWIDTH);
//    self.bgView.Y = SCREENHEIGHT - TANWIDTH;
//}
- (void)alertSelectViewshow {
    if (self.bgView) return;
    self.isOpen = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, TANWIDTH)];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.userInteractionEnabled = YES;
    [self creatUI];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.y = SCREENHEIGHT - TANWIDTH;
        
    }];
    [window addSubview:self];
}
//从右往左弹出
- (void)alertSelectViewshowLeft {
    if (self.bgView) return;
    self.isOpen = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, TANHIDTH, TANWIDTH)];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.userInteractionEnabled = YES;
    [self creatUI];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.blackView.userInteractionEnabled = YES;
    [self.blackView addGestureRecognizer:tap];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.x= SCREENWIDTH-TANHIDTH;
        
    }];
    [window addSubview:self];
}
-(void)creatUI{
    [self.bgView addSubview:self.DateView];
}
#pragma mark ====== 点击事件 ====
- (void)tap:(UITapGestureRecognizer *)tap {
    [self alertSelectViewClose];
}
- (void)alertSelectViewClose {
    self.isOpen = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.bgView.x!=0) {
            self.bgView.x = SCREENWIDTH;
        }else{
            self.bgView.y = SCREENHEIGHT;
        }
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
