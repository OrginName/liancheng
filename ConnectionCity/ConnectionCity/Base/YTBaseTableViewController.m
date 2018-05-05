//
//  YTBaseTableViewController.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTBaseTableViewController.h"

@interface YTBaseTableViewController ()

@end

@implementation YTBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)setupHeaderFooterView:(UIView *)view {
    [view isMemberOfClass:[UITableViewHeaderFooterView class]] ?((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor] : nil;
}

- (void)p_setupTableView {
    self.tableView.backgroundColor = kCommonBGColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    [[self class] setupHeaderFooterView:view];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    [[self class] setupHeaderFooterView:view];
}

@end
