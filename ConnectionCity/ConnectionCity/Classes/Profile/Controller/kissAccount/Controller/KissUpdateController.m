//
//  KissUpdateController.m
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "KissUpdateController.h"

@interface KissUpdateController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_nickName;
@property (weak, nonatomic) IBOutlet UILabel *lab_LCH;
@property (weak, nonatomic) IBOutlet UITextField *txt_weekCircle;
@property (weak, nonatomic) IBOutlet UITextField *txt_workTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_shareRadio;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;

@end

@implementation KissUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://忘记密码
            {
                
            }
            break;
        case 2://重置密码
        {
            
        }
            break;
        case 3://确认修改
        {
            
        }
            break;
        default:
            break;
    }
}
@end
