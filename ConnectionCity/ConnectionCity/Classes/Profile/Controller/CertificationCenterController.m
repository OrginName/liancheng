//
//  CertificationCenterController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CertificationCenterController.h"
#import "CardAuthorController.h"
@interface CertificationCenterController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_RZ1;
@property (weak, nonatomic) IBOutlet UILabel *lab_RZ2;
@property (weak, nonatomic) IBOutlet UILabel *lab_RZ3;

@end

@implementation CertificationCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==1) {
        [self.navigationController pushViewController:[super rotateClass:@"CardAuthorController"] animated:YES];
    }
}
-(void)setUI{
    self.navigationItem.title = @"认证中心";
}


@end