//  CustomScro.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "CustomScro.h"
@interface CustomScro()
@property (nonatomic,strong)UIView * viewLine;
@end
@implementation CustomScro
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr flag:(BOOL) flag{
    if (self = [super initWithFrame:frame]) {
        self.isShowLine = NO;
        [self addSubview:self.scrollView];
        float w = 0;
        for (int i=0; i<arr.count; i++) {
            float width = 0.0f;
            if (!flag) {
                width = [YSTools caculateTheWidthOfLableText:14 withTitle:arr[i]];
            }else{
                width=80;
            }
            NSLog(@"====%f------%@",width,arr[i]);
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10+w, 0, width, self.height)];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: flag?13:14];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            w = btn.frame.size.width + btn.frame.origin.x;
            if (flag) {
                [btn setImage:[UIImage imageNamed:@"weixuanhzong"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:4];
            }
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i+1;
            [self.scrollView addSubview:btn];
            self.scrollView.contentSize = CGSizeMake(width*arr.count, 0);
            if (i==0) {
                UIView * view= [[UIView alloc] initWithFrame:CGRectMake(btn.x, btn.height-2, btn.width, 2)];
                view.backgroundColor = [UIColor orangeColor];
                self.viewLine = view;
            }
        }
    }
    return self;
}
//滑动按钮点击方法
-(void)btnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CustomScroBtnClick:)]) {
        [self.delegate CustomScroBtnClick:btn];
    }
    if (self.viewLine) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viewLine.frame = CGRectMake(btn.x, btn.height-2, btn.width, 2);
        }];
    }
}
//是否显示滑动的view
-(void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    if (isShowLine) {
        [self.scrollView addSubview:self.viewLine];
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
//        _scrollView.backgroundColor = [UIColor redColor];
//        _scrollView.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
//        _scrollView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移，y向下偏移
//        _scrollView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//        _scrollView.layer.shadowRadius = 3;//阴影半径，默认3
    }
    return _scrollView;
}
@end
