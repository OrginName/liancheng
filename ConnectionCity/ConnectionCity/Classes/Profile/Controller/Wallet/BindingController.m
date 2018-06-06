//
//  BindingController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//   绑定账户

#import "BindingController.h"

@interface BindingController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_people;
@property (weak, nonatomic) IBOutlet UITextField *txt_type;
@property (weak, nonatomic) IBOutlet UITextField *txt_Account;
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_YZM;
@property (weak, nonatomic) IBOutlet UIButton *btn_YZM;

@end

@implementation BindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"绑定账号";
}
- (IBAction)btn_Click:(UIButton *)sender {
}

@end
