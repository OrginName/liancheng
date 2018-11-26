//
//  SecureController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SecureController.h"

@interface SecureController ()

@end

@implementation SecureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}
- (IBAction)btn_Close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];;
}
@end
