//
//  PrivateController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/7.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PrivateController.h"
#import "AddMyWayController.h"
@interface PrivateController ()
@property (weak, nonatomic) IBOutlet UISwitch *switch_Two;//是否允许陌生人查看
@property (weak, nonatomic) IBOutlet UISwitch *Switch_One;//加好友时需验证
@property (weak, nonatomic) IBOutlet UISwitch *Switch_Three;//朋友圈更新提醒
@property (nonatomic,strong)NSDictionary * dic;
@end
@implementation PrivateController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)setUI{
    self.navigationItem.title = @"隐私设置";
}
- (IBAction)PushClick:(UIButton *)sender {
    AddMyWayController * add = [AddMyWayController new];
    if (sender.tag==1) {
        add.index_receive = 1;
        add.title = @"添加我的方式";
    }else{
        add.index_receive = 2;
        add.title = @"通讯录黑名单";
    }
    add.dic = self.dic;
    [self.navigationController pushViewController:add animated:YES];
}
-(void)loadData{
    WeakSelf
    [YSNetworkTool POST:v1MyConfigGet params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dic = responseObject[@"data"];
            [self.Switch_One setOn:[responseObject[@"data"][@"openFriendVerify"] intValue]];
            [self.switch_Two setOn:[responseObject[@"data"][@"openStrangerViewTenPhoto"] intValue]];
            [self.Switch_Three setOn:[responseObject[@"data"][@"openFriendCircleNewRemind"] intValue]];
            
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
