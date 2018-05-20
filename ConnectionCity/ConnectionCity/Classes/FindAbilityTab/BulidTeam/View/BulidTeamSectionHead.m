//
//  BulidTeamSectionHead.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BulidTeamSectionHead.h"
#import "YSButton.h"
#import <Masonry.h>
@implementation BulidTeamSectionHead
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommonBGColor;
        //黄色横线
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:lineView];
        //展开箭头标识
        UIImageView *flagImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arraw-right"]];
        flagImgView.tag = 1000;
        [self.contentView addSubview:flagImgView];
        //名字
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor hexColorWithString:@"282828"];
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLab];
        //团队个数
        _teamNumbers = [[UILabel alloc]init];
        _teamNumbers.textColor = [UIColor hexColorWithString:@"989898"];
        _teamNumbers.font = [UIFont systemFontOfSize:14];
        _teamNumbers.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_teamNumbers];
        //区头视图点击事件
        YSButton *button = [YSButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1001;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(1);
        }];
        [flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(9, 15));
            make.centerY.equalTo(self).offset(5);
        }];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(flagImgView.mas_right).offset(10);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(self).offset(5);
        }];
        [_teamNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.equalTo(self).offset(-10);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(self).offset(5);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    self.backgroundColor = [UIColor redColor];
    return self;
}
//区头按钮绑定方法
- (void)headerButtonClick:(YSButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(bulidTeamSectionHead:headerButtonClick:)]) {
        [_delegate bulidTeamSectionHead:self headerButtonClick:button];
    }
}


@end
