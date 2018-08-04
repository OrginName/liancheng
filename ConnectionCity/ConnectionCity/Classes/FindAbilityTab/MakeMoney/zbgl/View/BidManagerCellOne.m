//
//  BidManagerCellOne.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerCellOne.h"

@implementation BidManagerCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _oneBtn.layer.cornerRadius = 10;
    _oneBtn.clipsToBounds = YES;
    _twoBtn.layer.cornerRadius = 10;
    _twoBtn.clipsToBounds = YES;
    _threeBtn.layer.cornerRadius = 10;
    _threeBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(orderListModel *)model {
    _model = model;
    _amountLab.text = model.amount;
    switch (model.status) {
        case 10:
        {
//            return @"待付款";
            [_oneBtn setTitle:@"  付款  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(250,82,84)];
            _oneBtn.hidden = NO;
            [_twoBtn setTitle:@"" forState:UIControlStateNormal];
            _twoBtn.hidden = YES;
            [_threeBtn setTitle:@"" forState:UIControlStateNormal];
            _threeBtn.hidden = YES;
            break;
        }
        case 20:
        {
//            return @"已支付";
            [_oneBtn setTitle:@"  已支付  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(237,104,68)];
            _oneBtn.hidden = NO;
            [_twoBtn setTitle:@"" forState:UIControlStateNormal];
            _twoBtn.hidden = YES;
            [_threeBtn setTitle:@"" forState:UIControlStateNormal];
            _threeBtn.hidden = YES;
            break;
        }
        case 30:
        {
//            return @"待交付";
            [_oneBtn setTitle:@"  已支付  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(237,104,68)];
            _oneBtn.hidden = NO;
            [_twoBtn setTitle:@"  待交付  " forState:UIControlStateNormal];
            [_twoBtn setBackgroundColor:YSColor(99,196,217)];
            _twoBtn.hidden = NO;
            [_threeBtn setTitle:@"" forState:UIControlStateNormal];
            _threeBtn.hidden = YES;
            break;
        }
        case 40:
        {
//            return @"交付中";
            [_oneBtn setTitle:@"  已支付  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(237,104,68)];
            _oneBtn.hidden = NO;
            [_twoBtn setTitle:@"  交付中  " forState:UIControlStateNormal];
            [_twoBtn setBackgroundColor:YSColor(86,164,237)];
            _twoBtn.hidden = NO;
            [_threeBtn setTitle:@"  确认  " forState:UIControlStateNormal];
            [_threeBtn setBackgroundColor:YSColor(244,153,48)];
            _threeBtn.hidden = NO;
            break;
        }
        case 50:
        {
//            return @"确认";
            [_oneBtn setTitle:@"  确认  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(244,153,48)];
            _oneBtn.hidden = NO;
            [_twoBtn setTitle:@"" forState:UIControlStateNormal];
            _twoBtn.hidden = YES;
            [_threeBtn setTitle:@"" forState:UIControlStateNormal];
            _threeBtn.hidden = YES;
            break;
        }
        case 60:
        {
//            return @"完成";
            [_oneBtn setTitle:@"  完成  " forState: UIControlStateNormal];
            [_oneBtn setBackgroundColor:YSColor(204,204,204)];
            _oneBtn.hidden = NO;
           [_twoBtn setTitle:@"" forState:UIControlStateNormal];
            _twoBtn.hidden = YES;
            [_threeBtn setTitle:@"" forState:UIControlStateNormal];
            _threeBtn.hidden = YES;
            break;
        }
        default:
            break;
    }
}
- (IBAction)btnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bidManagerCell:btn:)]) {
        [_delegate bidManagerCell:self btn:(UIButton *)sender];
    }
}

@end
