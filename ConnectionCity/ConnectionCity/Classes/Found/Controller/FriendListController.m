//
//  FriendListController.m
//  ConnectionCity
//
//  Created by qt on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendListController.h"
#import "FriendCirleTab.h"
#import "FriendMyselfTab.h"
#import "CustomButton.h"
#import "SendMomentController.h"
@interface FriendListController ()
{
    int i;
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet CustomButton *btn_picTxt;
@property (weak, nonatomic) IBOutlet CustomButton *btn_My;
@property (nonatomic,strong)FriendCirleTab * frendTab;
@property (nonatomic,strong)FriendMyselfTab * frendMyselfTab;
@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    i=0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)setUI{
    //    UIButton * btn = [self.view viewWithTag:1];
    //    btn.selected = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.view addSubview:self.frendTab];
    [self.view addSubview:self.frendMyselfTab];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SendFriend) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsZero];
    if ([self.tabBarItem.title isEqualToString:@"我的"]) {
        self.btn_picTxt.selected = NO;
        self.btn_My.selected = YES;
    }else{
        self.btn_picTxt.selected = YES;
        self.btn_My.selected = NO;
    }
}
//发布朋友圈
-(void)SendFriend{
    SendMomentController * send = [SendMomentController new];
    send.flagStr = @"HomeSend";
    send.block = ^{
//        [self.frendTab.mj_header beginRefreshing];
//        [self.frendVedio.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:send animated:YES];
}
- (IBAction)tagSelectClick:(CustomButton *)sender {
    if ([self.tabBarItem.title isEqualToString:@"圈子"]&&sender.tag!=1) {
        self.btn_picTxt.selected= NO;
    }else if ([self.tabBarItem.title isEqualToString:@"我的"]&&sender.tag!=3) {
        self.btn_My.selected= NO;
    }
     if(sender.tag==2){
        self.frendTab.hidden = YES;
        self.frendMyselfTab.hidden = NO;
        self.navigationItem.title = @"我的";
    }else{
        self.navigationItem.title = @"圈子";
        self.frendTab.hidden = NO;
        self.frendMyselfTab.hidden = YES;
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
//图文
-(FriendCirleTab *)frendTab{
    if (!_frendTab) {
        _frendTab = [[FriendCirleTab alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-134) withControll:self];
        _frendTab.hidden = NO;
    }
    return _frendTab;
}
//我的
-(FriendMyselfTab *)frendMyselfTab{
    if (!_frendMyselfTab) {
        _frendMyselfTab = [[FriendMyselfTab alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-134) style:UITableViewStyleGrouped withControll:self];
        _frendMyselfTab.hidden = YES;
    }
    return _frendMyselfTab;
}
-(void)back{
    if (self.tabBarController.tabBar.hidden) {
        i++;
        if (i==1) {
            self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.selectedIndex = 0;
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
