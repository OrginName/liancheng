//
//  FriendCircleController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendCircleController.h"
#import "CustomButton.h"
#import "FriendCirleTab.h"
static NSInteger i;//判断当前返回按钮点击次数
@interface FriendCircleController ()
{
    UIButton * _tmpBtn;
}
@property (nonatomic,strong)FriendCirleTab * frendTab;
@end

@implementation FriendCircleController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    i=0;
}
- (IBAction)tagSelectClick:(CustomButton *)sender {
    UIButton * btn = [self.view viewWithTag:1];
    if (sender.tag!=1) {
        btn.selected= NO;
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
    UIButton * btn = [self.view viewWithTag:1];
    btn.selected = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.view addSubview:self.frendTab];
}
-(FriendCirleTab *)frendTab{
    if (!_frendTab) {
        _frendTab = [[FriendCirleTab alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-134) withControll:self];
    }
    return _frendTab;
}
-(void)back{
    if (self.tabBarController.tabBar.hidden) {
        i++;
        if (i==1) {
            self.tabBarController.tabBar.hidden = NO;
        }else{
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
            self.tabBarController.tabBar.selectedItem = 0;
        }
    }else{
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
}
@end
