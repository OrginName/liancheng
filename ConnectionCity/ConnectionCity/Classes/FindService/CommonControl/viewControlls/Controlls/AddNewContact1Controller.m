//
//  AddNewContact1Controller.m
//  ConnectionCity
//
//  Created by qt on 2018/12/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddNewContact1Controller.h"
#import "PersonNet.h"
#import "privateUserInfoModel.h"
@interface AddNewContact1Controller ()

@end

@implementation AddNewContact1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.txt_phone becomeFirstResponder];
}
- (IBAction)addClick:(UIButton *)sender {
    if ([YSTools dx_isNullOrNilWithObject:self.txt_phone.text]&&self.txt_phone.text.length!=11) {
        return [YTAlertUtil showTempInfo:@"请输入正确的手机号"];
    }
    if ([YSTools dx_isNullOrNilWithObject:self.txt_name.text]) {
        return [YTAlertUtil showTempInfo:@"请输入名字"];
    }
    NSDictionary * dic = @{
                           @"id": [[YSAccountTool userInfo] modelId],
                           @"mobile": self.txt_phone.text,
                           @"name": self.txt_name.text
                           };
    WeakSelf
    [PersonNet requstAddContact:dic withDic:^(NSDictionary *successDicValue) {
        if (weakSelf.blcok) {
            weakSelf.blcok();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } FailDicBlock:nil];
}
@end
