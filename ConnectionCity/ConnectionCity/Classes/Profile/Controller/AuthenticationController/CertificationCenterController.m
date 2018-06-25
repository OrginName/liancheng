//
//  CertificationCenterController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CertificationCenterController.h"
#import "CardAuthorController.h"
#import "CertificationCenterMo.h"

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
    WeakSelf
    [YSNetworkTool POST:v1MyAuthInfo params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        CertificationCenterMo *model = [CertificationCenterMo mj_objectWithKeyValues:responseObject[@"data"]];
        NSLog(@"%@",model.mobileInfo);
        weakSelf.lab_RZ1.text = model.mobileInfo?model.mobileInfo:@"未认证";
        weakSelf.lab_RZ2.text = model.identityInfo?model.identityInfo:@"未认证";
        weakSelf.lab_RZ3.text = model.skillInfo?model.skillInfo:@"未认证";
    } failure:nil];
}

@end
