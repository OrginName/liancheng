//
//  AccountSecurityController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccountSecurityController.h"

@interface AccountSecurityController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_Phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;
@property (weak, nonatomic) IBOutlet UIButton *btn_SelectOpen;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom2;
@property (weak, nonatomic) IBOutlet UIView *view_bottom1;
 
@end

@implementation AccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}
- (IBAction)openPhoneClick:(UIButton *)sender {
    if (sender.tag==2) {
        AccountSecurityController * cont = [AccountSecurityController new];
        cont.str = @"flag1";
        [self.navigationController pushViewController:cont animated:YES];
    }else if(sender.tag==3){
        self.btn_SelectOpen.selected = !self.btn_SelectOpen.selected;
    }else if (sender.tag==5){
        [YTAlertUtil showTempInfo:@"提交"];
    }
}
-(void)setUI{
    self.navigationItem.title = @"账号安全";
    if ([self.str isEqualToString:@"flag1"]) {
        self.view_bottom1.hidden = NO;
        self.view_Bottom2.hidden = YES;
    }else{
        self.view_bottom1.hidden = YES;
        self.view_Bottom2.hidden = NO;
    }
}
@end
