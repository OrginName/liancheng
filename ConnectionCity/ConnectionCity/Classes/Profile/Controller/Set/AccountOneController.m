//
//  AccountOneController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountOneController.h"
#import "AccountSecurityController.h"
@interface AccountOneController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;
@property (weak, nonatomic) IBOutlet UILabel *lab_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_LCPassword;
@property (weak, nonatomic) IBOutlet UILabel *lab_Email;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom1;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom2;
@property (weak, nonatomic) IBOutlet UITextField *txt_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txt_NewPass;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPassAgain;

@end

@implementation AccountOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.str isEqualToString:@"AccountTwo"]) {
        self.view_Bottom1.hidden = NO;
        self.view_Bottom2.hidden = YES;
        self.navigationItem.title = @"修改密码";
    }else{
        self.view_Bottom1.hidden = YES;
        self.view_Bottom2.hidden = NO;
        self.navigationItem.title = @"账号安全";

    }
}
- (IBAction)BDPhoneClick:(UIButton *)sender {
    if (sender.tag==1) {
        AccountSecurityController * account = [AccountSecurityController new];
        [self.navigationController pushViewController:account animated:YES];
    }else if(sender.tag==2){
        [YTAlertUtil showTempInfo:@"邮箱绑定"];
    }else if (sender.tag==3){
        AccountOneController * account = [AccountOneController new];
        account.str = @"AccountTwo";
        [self.navigationController pushViewController:account animated:YES];
    }else if (sender.tag==8){
        [YTAlertUtil showTempInfo:@"确定"];
    }
 
}
@end
