//
//  SecureController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SecureController.h"
#import "AddContactController.h"
@interface SecureController ()

@end

@implementation SecureController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (IBAction)btn_add:(UIButton *)sender {
    AddContactController * add =[AddContactController new];
    add.title = @"紧急联系人";
    [self.navigationController pushViewController:add animated:YES];
}
- (IBAction)btn_Close:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];;
}
@end
