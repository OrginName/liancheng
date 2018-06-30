//
//  BidderSectionHeadV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidderSectionHeadV.h"

@implementation BidderSectionHeadV
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
        //下部背景
        UIView *downBgView = [[UIView alloc]init];
        downBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:downBgView];
        //头部图片
        _headerImgV = [[UIImageView alloc]init];
        //_headerImgV.image = [UIImage imageNamed:@"Bid"];
        [downBgView addSubview:_headerImgV];
        //投标人
        _bidderLab = [[UILabel alloc]init];
        _bidderLab.font = [UIFont systemFontOfSize:17];
        //_bidderLab.text = @"投标人";
        [downBgView addSubview:_bidderLab];
        
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
        [downBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(upBgView.mas_bottom).offset(3);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(19);
            make.centerY.equalTo(downBgView.mas_centerY);
        }];
        [_bidderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(_headerImgV.mas_right).offset(10);
            make.right.equalTo(downBgView.mas_right).offset(-10);
        }];
    }
    self.backgroundColor = [UIColor redColor];
    return self;
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    self.titleLab.text = model.title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
