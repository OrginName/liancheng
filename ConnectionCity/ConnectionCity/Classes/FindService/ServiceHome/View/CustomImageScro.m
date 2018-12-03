//
//  CustomImageScro.m
//  ConnectionCity
//
//  Created by umbrella on 2018/8/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomImageScro.h"
@implementation CustomImageScro
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        for (int i=0; i<arr.count; i++) {
            float width = 0.0f;
            width=self.height-10;
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5+i*(width+10), 5, width, width)];
            if ([arr[i] containsString:@"http"]) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:arr[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo2"]];
            }else
                [btn setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            btn.layer.cornerRadius = width/2;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i+1;
            self.scrollView.contentSize = CGSizeMake((width+10)*arr.count, 0);
            [self.scrollView addSubview:btn];
        } 
    }
    return self;
}

-(void)btnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CustomScroIMGClick:)]) {
        [self.delegate CustomScroIMGClick:btn];
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
