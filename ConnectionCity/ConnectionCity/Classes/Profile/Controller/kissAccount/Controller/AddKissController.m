//
//  AddKissController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddKissController.h"

@interface AddKissController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;//连城号
@property (weak, nonatomic) IBOutlet UITextField *txt_workCircle;//工作周期
@property (weak, nonatomic) IBOutlet UITextField *txt_worTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_ShareRadio;//共享比例
@property (weak, nonatomic) IBOutlet UITextField *txt_TALCH;//对方的连城号
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@end

@implementation AddKissController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 绑定亲密账户

 @param sender btn
 */
- (IBAction)sureClick:(UIButton *)sender {
}

@end
