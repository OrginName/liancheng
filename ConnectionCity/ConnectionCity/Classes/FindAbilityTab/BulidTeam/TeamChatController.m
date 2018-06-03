//
//  TeamChatController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TeamChatController.h"
#import "TeamInfoController.h"

@interface TeamChatController ()

@end

@implementation TeamChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"需求团队群";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(teamClick) image:@"team" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
#pragma mark - 点击事件
- (void)teamClick {
    TeamInfoController *teamInfoVC = [[TeamInfoController alloc]init];
    [self.navigationController pushViewController:teamInfoVC animated:YES];
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
