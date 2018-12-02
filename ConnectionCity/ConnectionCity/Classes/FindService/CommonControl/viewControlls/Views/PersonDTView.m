//
//  PersonDTView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonDTView.h"
#import "UserMo.h"
#import "PersonNet.h"
@interface PersonDTView()
@property (weak, nonatomic) IBOutlet UIButton *btn_GZ;
@property (weak, nonatomic) IBOutlet UILabel *lab_HZNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_FSNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_FBNum;
@property (weak, nonatomic) IBOutlet UIImageView *imag_bac;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@end
@implementation PersonDTView
-(void)setReceiveDic:(NSDictionary *)receiveDic{
    _receiveDic = receiveDic;
    NSDictionary * dic = receiveDic[kData];
    if ([[dic[@"isFollow"] description] isEqualToString:@"0"]) {
        [self.btn_GZ setTitle:@"关注" forState:UIControlStateNormal];
    }else
        [self.btn_GZ setTitle:@"关注" forState:UIControlStateNormal];
    UserMo * user = [UserMo mj_objectWithKeyValues:receiveDic[kData][@"user"]];
    [self.imag_bac sd_setImageWithURL:[NSURL URLWithString:user.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:user.headImage] placeholderImage:[UIImage imageNamed:@"2"]];
    self.lab_Name.text = user.nickName;
    self.lab_FBNum.text = [receiveDic[kData][@"publishCount"] description]?[receiveDic[kData][@"publishCount"] description]:@"0";
    self.lab_FSNum.text = [receiveDic[kData][@"followCount"] description]?[receiveDic[kData][@"followCount"] description]:@"0";
    self.lab_HZNum.text = [receiveDic[kData][@"likeCount"] description]?[receiveDic[kData][@"likeCount"] description]:@"0";
}
- (IBAction)GZClick:(UIButton *)sender {
    NSString * ID = [self.receiveDic[kData][@"user"][@"id"] description];
    [PersonNet requstGZ:@{@"followUseId":ID} withArr:^(NSDictionary *successDicValue) {

    } FailDicBlock:nil];
}
@end
