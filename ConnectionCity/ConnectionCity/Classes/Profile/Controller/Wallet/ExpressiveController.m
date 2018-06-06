//
//  ExpressiveController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ExpressiveController.h"

@interface ExpressiveController ()

@end

@implementation ExpressiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"提现";
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==1) {
        [self.navigationController pushViewController:[super rotateClass:@"PresentManageViewController"] animated:YES];
    }else{
        [YTAlertUtil showTempInfo:@"申请提现"];
    }
}

@end
