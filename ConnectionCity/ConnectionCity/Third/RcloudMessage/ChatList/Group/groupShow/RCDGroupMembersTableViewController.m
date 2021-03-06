//
//  RCDGroupMembersTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/4/10.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDGroupMembersTableViewController.h"
#import "DefaultPortraitView.h"
#import "RCDAddFriendViewController.h"
#import "RCDContactTableViewCell.h"
#import "RCDPersonDetailViewController.h"
#import "RCDUIBarButtonItem.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "PersonalBasicDataController.h"
#import "UserMo.h"
@interface RCDGroupMembersTableViewController ()

@property(nonatomic, strong) RCDUIBarButtonItem *leftBtn;

@end

@implementation RCDGroupMembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation
    // bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];

    self.title = [NSString stringWithFormat:@"群组成员(%lu)", (unsigned long)[_GroupMembers count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_GroupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
    }
    // Configure the cell...
    RCDUserInfo *user = _GroupMembers[indexPath.row];
    if ([user.portraitUri isEqualToString:@""]) {
        DefaultPortraitView *defaultPortrait = [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [defaultPortrait setColorAndLabel:user.userId Nickname:user.name];
        UIImage *portrait = [defaultPortrait imageFromView];
        cell.portraitView.image = portrait;
    } else {
        [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri]
                             placeholderImage:[UIImage imageNamed:@"contact"]];
    }
    cell.portraitView.layer.masksToBounds = YES;
    cell.portraitView.layer.cornerRadius = 5.f;
    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;

    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    cell.nicknameLabel.text = user.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCUserInfo *user = _GroupMembers[indexPath.row];
    [YSNetworkTool POST:v1PrivateUserUserinfo params:@{@"id":user.userId} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        UserMo * mo = [UserMo mj_objectWithKeyValues:responseObject[@"data"]];
        PersonalBasicDataController * person = [PersonalBasicDataController new];
        person.connectionMo = mo;
        [self.navigationController pushViewController:person animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
