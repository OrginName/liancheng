//
//  FootSectionHeadV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FootSectionHeadV.h"

@implementation FootSectionHeadV
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kCommonBGColor;
        //上部背景
        UIView *upBgView = [[UIView alloc]init];
        upBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:upBgView];
        //头部图片
        _headerImgV = [[UIImageView alloc]init];
        _headerImgV.image = [UIImage imageNamed:@"Bid"];
        [upBgView addSubview:_headerImgV];
        //投标人
        _bidderLab = [[UILabel alloc]init];
        _bidderLab.font = [UIFont systemFontOfSize:17];
        _bidderLab.text = @"投标人";
        [upBgView addSubview:_bidderLab];
        //中标人数
        _winNumbersLab = [[UILabel alloc]init];
        _winNumbersLab.font = [UIFont systemFontOfSize:12];
        _winNumbersLab.text = @"(2)";
        [upBgView addSubview:_winNumbersLab];
        //下部背景
        UIView *downBgView = [[UIView alloc]init];
        downBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:downBgView];
        //标题
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = YSColor(101,101,101);
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.text = @"海通证卷大厦三十五楼室内装修工程";
        [downBgView addSubview:_titleLab];
        
        [upBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(50);
        }];
        [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(19);
            make.centerY.equalTo(upBgView.mas_centerY);
        }];
        [_bidderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(_headerImgV.mas_right).offset(10);
            make.right.equalTo(_winNumbersLab.mas_left).offset(-10);
        }];
        [_winNumbersLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(_bidderLab.mas_right).offset(10);
            make.right.mas_equalTo(-10);
        }];
        [downBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(upBgView.mas_bottom).offset(1);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(downBgView.mas_left).offset(10);
            make.right.equalTo(downBgView.mas_right).offset(-10);
        }];
    }
    self.backgroundColor = [UIColor redColor];
    return self;
}

- (void)setModel:(FirstControllerMo *)model{
    _model = model;
    self.titleLab.text = model.title;
    if ([model.isWin isEqualToString:@"1"]) {
        self.headerImgV.image = [UIImage imageNamed:@"Win"];
        self.bidderLab.text = @"中标";
        self.winNumbersLab.hidden = NO;
    }else{
        self.headerImgV.image = [UIImage imageNamed:@"Bid"];
        self.bidderLab.text = @"投标";
        self.winNumbersLab.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
