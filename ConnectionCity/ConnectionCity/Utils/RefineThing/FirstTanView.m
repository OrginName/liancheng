//
//  FirstTanView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "FirstTanView.h"
#import "AddressBookController.h"
#import "YSConstString.h"
#import "SendServiceController.h"
#import "SendTripController.h"
#import "ReleaseTenderController.h"
#import "SendSwapController.h"
@implementation FirstTanView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.txt_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txt_view.layer.cornerRadius = 5;
    self.btn_TJ.layer.borderColor = [UIColor orangeColor].CGColor;
    self.btn_TJ.layer.borderWidth = 1;
    self.btn_PJ.layer.borderColor = [UIColor orangeColor].CGColor;
    self.btn_PJ.layer.borderWidth = 1;
}
-(void)setUserInfo:(RCDUserInfo *)userInfo{
    _userInfo = userInfo;
    if (userInfo!=nil) {
            [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[userInfo.backGroundImage description]] placeholderImage:[UIImage imageNamed:@"2"]];
             [self.image_heda sd_setImageWithURL:[NSURL URLWithString:[userInfo.portraitUri description]] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        self.image_Sex.image =[UIImage imageNamed:[[userInfo.genderName description] isEqualToString:@"男"]?@"men":@"women"];
        self.lab_nickName.text = [userInfo.name description];\
        if ([[userInfo.sign description] containsString:@"null"]) {
            self.lab_signature.text = @"";
        }else
        self.lab_signature.text = [userInfo.sign description]?[userInfo.sign description]:@"";
    }
}
- (IBAction)FirstTanClick:(UIButton *)sender {
    if (sender.tag==5) {
        
    }else{
        NSArray * arr = @[@"SendServiceController",@"SendTripController",@"ReleaseTenderController",@"SendSwapController"];
        [self.messController.navigationController pushViewController:[self rotateClass:arr[sender.tag-1]] animated:YES];
//        AddressBookController * address = [AddressBookController new];
//        address.title = @"测试标题";
//       [self.messController.navigationController pushViewController:address animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
}
/**
 提交按钮点击事件

 @param sender btn
 */
- (IBAction)submitClick:(UIButton *)sender {
    if (sender.tag==1) {
        if (self.txt_view.text.length==0) {
            return [YTAlertUtil showTempInfo:@"请输入取消原因"];
        }
        self.block(self.txt_view.text);
    }else{
        if (self.txtView_PJ.text.length==0) {
            return [YTAlertUtil showTempInfo:@"请输入评价内容"];
        }
        self.block(self.txtView_PJ.text);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
}
/**
 类名转换类
 
 @param name 类名
 */
-(UIViewController *)rotateClass:(NSString *)name{
    Class c = NSClassFromString(name);
    UIViewController * controller;
#if __has_feature(objc_arc)
    controller = [[c alloc] init];
#else
    controller = [[[c alloc] init] autorelease];
#endif
    return controller;
}
@end
