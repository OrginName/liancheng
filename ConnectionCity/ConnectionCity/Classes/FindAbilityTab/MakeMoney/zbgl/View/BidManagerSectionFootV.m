//
//  BidManagerSectionFootV.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManagerSectionFootV.h"

@implementation BidManagerSectionFootV
- (void)awakeFromNib {
    [super awakeFromNib];
    _changeBtn.layer.cornerRadius = 3;
    _changeBtn.layer.borderWidth = 1;
    _changeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _deleteBtn.layer.cornerRadius = 3;
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _negotiationBtn.layer.cornerRadius = 3;
    _negotiationBtn.layer.borderWidth = 1;
    _negotiationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Initialization code
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)changeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(BidManagerSectionFootV:changeBtnClick:)]) {
        [_delegate BidManagerSectionFootV:self changeBtnClick:(UIButton *)sender];
    }
}
- (IBAction)deleteBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(BidManagerSectionFootV:deleteBtnClick:)]) {
        [_delegate BidManagerSectionFootV:self deleteBtnClick:(UIButton *)sender];
    }
}
- (IBAction)negotiationBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(BidManagerSectionFootV:negotiationBtnClick:)]) {
        [_delegate BidManagerSectionFootV:self negotiationBtnClick:(UIButton *)sender];
    }
}
- (void)setModel:(FirstControllerMo *)model {
    _model = model;
    //    状态-审核中、招标中、中标、结束
    if([model.status integerValue]==1){
        _reviewStatusLab.text = @"审核中";
        _changeBtn.hidden = NO;
        _deleteBtn.hidden = NO;
        _negotiationBtn.hidden = YES;
    }else if([model.status integerValue]==2){
        _reviewStatusLab.text = @"招标中";
        _changeBtn.hidden = YES;
        _deleteBtn.hidden = NO;
        _negotiationBtn.hidden = YES;
    }else if([model.status integerValue]==3){
        _reviewStatusLab.text = @"中标";
        _changeBtn.hidden = YES;
        _deleteBtn.hidden = YES;
        _negotiationBtn.hidden = NO;
    }else if([model.status integerValue]==3){
        _reviewStatusLab.text = @"结束";
        _changeBtn.hidden = YES;
        _deleteBtn.hidden = NO;
        _negotiationBtn.hidden = YES;
    }
}
@end
