//
//  AboutOurController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AboutOurController.h"
#import "AgreementController.h"
#import "CommonNet.h"
@interface AboutOurController ()
{
    NSString * str_bundle;
}
@property (weak, nonatomic) IBOutlet UILabel *lab_bundle;

@end

@implementation AboutOurController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于连程";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    str_bundle = appCurVersion;
    self.lab_bundle.text = KString(@"V %@", appCurVersion);
}
- (IBAction)BtnClick:(UIButton *)sender {
    NSArray * arr = @[privacyAgreement,connectRule,useAgreement,userBehaviorStandard,serviceAgreement,about];
    if (sender.tag==1) {
        [CommonNet CheckVersion:true];
    }else if (sender.tag==7){ 
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.url = KString(@"%@/contact/index", baseUrl);
        agreementVC.title = @"联系我们";
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else{
        AgreementController *agreementVC = [[AgreementController alloc]init];
        agreementVC.alias = arr[sender.tag-2];
        [self.navigationController pushViewController:agreementVC animated:YES];
    }
}
@end
