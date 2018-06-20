//
//  IdentityAuthorController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "IdentityAuthorController.h"
#import "TakePhoto.h"
@interface IdentityAuthorController ()
@property (weak, nonatomic) IBOutlet UIButton *btn_select1;
@property (weak, nonatomic) IBOutlet UIButton *btn_select2;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;

@end

@implementation IdentityAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self requestData];

}
-(void)setUI{
    self.navigationItem.title = @"身份认证";
}
- (IBAction)PhotoSelect:(UIButton *)sender {
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag+3];
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [sender setBackgroundImage:image forState:UIControlStateNormal];
        btn.hidden = NO;
    }];
}
- (IBAction)DeleteClick:(UIButton *)sender {
    if (sender.tag == 4) {
        [YTAlertUtil showTempInfo:@"提交认证"];
        return;
    }
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag-3];
    [btn setBackgroundImage:[UIImage imageNamed:@"jia200-5"] forState:UIControlStateNormal];
    sender.hidden = YES;
}
- (void)requestData {
    [YSNetworkTool POST:myAuthUserIdentityAuthCreate params:nil showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:nil];
}
@end
