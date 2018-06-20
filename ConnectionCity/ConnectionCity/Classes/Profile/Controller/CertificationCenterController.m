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
    [self requestData];
}
- (IBAction)btnClick:(UIButton *)sender {
    NSArray * arr = @[@"CardAuthorController",@"IdentityAuthorController",@"SkillCertificationController"];
    [self.navigationController pushViewController:[super rotateClass:arr[sender.tag-1]] animated:YES];
    
}
-(void)setUI{
    self.navigationItem.title = @"认证中心";
}
- (void)requestData {
    [YSNetworkTool POST:myAuthAuth params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}

@end
