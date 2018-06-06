//
//  ExchangeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ExchangeController.h"

@interface ExchangeController ()

@end

@implementation ExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"兑换服币";
}
- (IBAction)BtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        [self.navigationController pushViewController:[super rotateClass:@"RechargeController"] animated:YES];
    }
}
@end
