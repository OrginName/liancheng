//
//  viewPaly.m
//  ConnectionCity
//
//  Created by umbrella on 2018/7/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "viewPaly.h"
@interface viewPaly()
@property (nonatomic,strong)UIButton * btn_back;
@property (nonatomic,strong)UIImageView * image_cover;
@property (nonatomic,strong)UIButton * btn_play;
@property (nonatomic,strong)UIView * coverView;
@end
@implementation viewPaly
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.playView];
        [self.playView addSubview:self.coverView];
        [self.coverView addSubview:self.btn_back];

//        [self addSubview:self.coverView];
//        [self bringSubviewToFront:self.coverView];
//        [self.coverView addSubview:self.btn_back];
        // 单击
//
    }
    return self;
}
-(void)animateShow{
    [UIView animateWithDuration:1 animations:^{
        self.frame = [[UIScreen mainScreen] bounds];
    }];
}
-(void)closed{
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectZero;
        [self.playView pause];
    }];
}
//返回方法
-(void)Back{
//    self.tapBigView();
    [self closed];
}
-(void)singleTapGestureCallback{
//    self.tapBigView();
    [self closed];
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.coverView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    self.btn_back.frame = CGRectMake(10, 44, 60, 64);
    self.playView.frame = self.frame;
}
-(UIButton *)btn_back{
    if (!_btn_back) {
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_back setImage:[UIImage imageNamed:@"return-f"] forState:UIControlStateNormal];
        [_btn_back addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_back;
}
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback)];
        [_coverView addGestureRecognizer:singleTap];
    }
    return _coverView;
}
#pragma mark -----视频预览-------
-(CustomPlayer *)playView{
    if (!_playView) {
        _playView = [[CustomPlayer alloc] init];
    }
    return _playView;
}
@end
