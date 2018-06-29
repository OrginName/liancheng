//
//  CustomScro.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomScro.h"
@implementation CustomScro
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.scrollView];
        for (int i=0; i<arr.count; i++) {
            float width = [YSTools caculateTheWidthOfLableText:14 withTitle:arr[i]]+10;
            if (width<40) {
                width=40;
            }
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, self.height)];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i+1;
            [self.scrollView addSubview:btn];
            self.scrollView.contentSize = CGSizeMake(width*arr.count, 0);
        }
    }
    return self;
}
-(void)btnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:btn.tag];
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
