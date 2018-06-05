//
//  MemberRenewalController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MemberRenewalController.h"

@interface MemberRenewalController ()

@end

@implementation MemberRenewalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI{
    self.navigationItem.title = @"会员续费";
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
