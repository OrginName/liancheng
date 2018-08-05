//
//  JKReusableView.m
//  CIO领域demo
//
//  Created by 王冲 on 2017/11/14.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

#import "JKReusableView.h"

@implementation JKReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, kScreenWidth-69-9, 1)];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
        
//        /*
//         *  图片的添加
//         */
//        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 11, 18, 18)];
//        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
//        _iconImage.layer.cornerRadius = 4;
//        _iconImage.clipsToBounds = YES;
//        _iconImage.alpha = 1;
//        [self addSubview:_iconImage];
        
        _headText = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-105, self.height)];
        //_headText.backgroundColor = JKRandomColor;
        _headText.font = [UIFont systemFontOfSize:15];
        _headText.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_headText];
        
    }
    return self;
}


@end

