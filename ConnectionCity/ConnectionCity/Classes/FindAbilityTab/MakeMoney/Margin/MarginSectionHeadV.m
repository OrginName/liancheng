//
//  MarginSectionHeadV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MarginSectionHeadV.h"

@implementation MarginSectionHeadV
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommonBGColor;
        //上部背景
        UIView *upBgView = [[UIView alloc]init];
        upBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:upBgView];
        //蓝色圆点
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = YSColor(61,187,165);
        lineView.layer.cornerRadius = 4;
        [upBgView addSubview:lineView];
        //标题
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = YSColor(101,101,101);
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.text = @"海通证卷大厦三十五楼室内装修工程";
        [upBgView addSubview:_titleLab];
        
        [upBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(8);
            make.width.mas_equalTo(8);
            make.centerY.equalTo(upBgView.mas_centerY);
        }];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(lineView.mas_right).offset(10);
            make.right.equalTo(upBgView.mas_right).offset(-10);
        }];
    }
    self.backgroundColor = [UIColor redColor];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
