//
//  PersonalBasicDataController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonalBasicDataController.h"
#import "EditAllController.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDChatViewController.h"
@interface PersonalBasicDataController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutMu;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *lcNumLab;
@property (weak, nonatomic) IBOutlet UILabel *beiZhuLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;

@end

@implementation PersonalBasicDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setConnectionMo:self.connectionMo];
}
-(void)setConnectionMo:(UserMo *)connectionMo{
    _connectionMo = connectionMo;
    if (_connectionMo!=nil) {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:connectionMo.backgroundImage] placeholderImage:[UIImage imageNamed:@"2"]];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:connectionMo.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        self.sexImage.image =[UIImage imageNamed:[connectionMo.gender isEqualToString:@"1"]?@"women":@"men"];
        self.nickNameLab.text = connectionMo.nickName?connectionMo.nickName:connectionMo.ID;
        self.introduceLab.text = connectionMo.sign?connectionMo.sign:@"";
        self.lcNumLab.text = connectionMo.ID;
        self.phoneNumLab.text = connectionMo.mobile;
        self.addressLab.text = connectionMo.cityName;
        if ([[connectionMo.isFriend description] isEqualToString:@"1"]) {
            self.layoutMu.constant = (kScreenWidth-50)/2-40;
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"基础资料";
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
}
#pragma mark - 点击事件
- (IBAction)sendMessageBtnClick:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag==1) {
        [RCDHTTPTOOL requestFriend:self.connectionMo.ID complete:^(BOOL result) {
            if (result) {
                [YTAlertUtil showTempInfo:@"好友申请已发送"];
            }
        }];
    }else{
        RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
        chatViewController.conversationType = ConversationType_PRIVATE;
        
        chatViewController.targetId = [self.connectionMo.ID description];
        NSString *title;
        if ([KString(@"%@", self.connectionMo.ID) isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            title = [RCIM sharedRCIM].currentUserInfo.name;
        } else {
//            if (self.friendInfo.displayName.length > 0) {
//                title = self.friendInfo.displayName;
//            } else {
            title = self.connectionMo.nickName?self.connectionMo.nickName:self.connectionMo.ID;
//            }
        }
        chatViewController.title = title;
//        chatViewController.needPopToRootView = YES;
        chatViewController.displayUserNameInCell = NO;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}
- (IBAction)beizhuBtnClick:(id)sender {
    EditAllController * edit = [EditAllController new];
    WeakSelf
    edit.block = ^(NSString * str){
        weakSelf.beiZhuLab.text = str;
    };
    [self.navigationController pushViewController:edit animated:YES];
}
@end
