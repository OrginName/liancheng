//
//  FriendCircleController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyCircleController.h"
#import "CustomButton.h"
#import "FriendCirleTab.h"
#import "FriendVideo.h"
#import "FriendMyselfTab.h"
#import "SendMomentController.h"
#import <IQKeyboardManager.h>
#import "privateUserInfoModel.h"
static NSInteger i;//判断当前返回按钮点击次数
@interface MyCircleController ()
{
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet CustomButton *btn_video;
@property (weak, nonatomic) IBOutlet CustomButton *btn_picTxt;
@property (weak, nonatomic) IBOutlet CustomButton *btn_My;
@property (nonatomic,strong)FriendCirleTab * frendTab;
@property (nonatomic,strong)FriendVideo * frendVedio;
@end

@implementation MyCircleController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    self.tabBarController.tabBar.hidden = YES;
    i=0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.navigationItem.title = @"服务圈";
}
//发布朋友圈
-(void)SendFriend{
    SendMomentController * send = [SendMomentController new];
    send.block = ^{
        [self.frendTab.mj_header beginRefreshing];
        [self.frendVedio.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)tagSelectClick:(CustomButton *)sender {
    if (sender.tag!=1) {
        self.btn_picTxt.selected= NO;
    }else if (sender.tag!=3) {
        self.btn_My.selected= NO;
    }
    if (sender.tag==2) {
        self.frendTab.hidden = YES;
        self.frendVedio.hidden = NO;
    }else if(sender.tag==3){
        self.frendTab.hidden = YES;
        self.frendVedio.hidden = YES;
    }else{
        self.frendTab.hidden = NO;
        self.frendVedio.hidden = YES;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}

-(void)setUI{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return-f"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.view addSubview:self.frendTab];
    [self.view addSubview:self.frendVedio];
    privateUserInfoModel * user = (privateUserInfoModel *)[YSAccountTool userInfo];
    UserMo * user1 = [UserMo new];
    user1.ID = user.modelId;
    user1.backgroundImage = user.backgroundImage;
    user1.nickName = user.nickName;
    user1.headImage = user.headImage;
    self.frendTab.user = user1;
    self.frendTab.flagStr = @"MYSELFCIRCLE";
    self.frendVedio.user = user1;
    if (self.user==nil) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SendFriend) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsZero];
    }
    if ([self.tabBarItem.title isEqualToString:@"我的"]) {
        self.btn_picTxt.selected = NO;
        self.btn_My.selected = YES;
        self.frendTab.hidden = YES;
        self.frendVedio.hidden = YES;
    }else{
        self.btn_picTxt.selected = YES;
        self.btn_My.selected = NO;
        self.frendTab.hidden = NO;
        self.frendVedio.hidden = YES;
    }
}
//图文
-(FriendCirleTab *)frendTab{
    if (!_frendTab) {
        _frendTab = [[FriendCirleTab alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-134) withControll:self];
        _frendTab.hidden = NO;
        
    }
    return _frendTab;
}
//视频
-(FriendVideo *)frendVedio{
    if (!_frendVedio) {
        _frendVedio = [[FriendVideo alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-134) collectionViewLayout:[UICollectionViewFlowLayout new] withController:self];
        _frendVedio.hidden = YES;
    }
    return _frendVedio;
}
-(void)back{
    if (self.tabBarController.tabBar.hidden) {
        i++;
        if (i==1) {
            if (self.user!=nil) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.selectedIndex = 0;
        }else{
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (self.user!=nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.frendTab.comment removeFromSuperview];
    self.frendTab.comment =nil;
}
@end
