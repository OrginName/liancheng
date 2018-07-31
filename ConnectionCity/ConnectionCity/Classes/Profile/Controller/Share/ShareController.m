//
//  ShareController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShareController.h"

@interface ShareController ()

@end

@implementation ShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI{
    self.navigationItem.title = @"邀请加盟";
}
- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
        {
            [YSShareTool share:SSDKPlatformSubTypeWechatSession];
            break;
        }
        case 101:
        {
            [YSShareTool share:SSDKPlatformSubTypeWechatTimeline];
            break;
        }
        case 102:
        {
            [YSShareTool share:SSDKPlatformTypeQQ];
            break;
        }
        case 103:
        {
            [YSShareTool share:SSDKPlatformTypeSinaWeibo];
            break;
        }
        case 104:
        {
            [YTAlertUtil showTempInfo:@"二维码"];
            break;
        }
        case 105:
        {
            [YTAlertUtil showTempInfo:@"邀请规则"];
            break;
        }
        default:
            break;
    }
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
