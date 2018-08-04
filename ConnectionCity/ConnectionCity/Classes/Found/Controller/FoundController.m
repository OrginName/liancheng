//
//  FoundController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FoundController.h"
#import "FoundCell.h"
#import "NearManController.h"
#import "FriendListController.h"
#import "YCProjectScanningController.h"
#import "RCDHttpTool.h"

@interface FoundController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation FoundController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}
#pragma mark - Setup
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
        [self.tableView registerNib:[UINib nibWithNibName:@"FoundCell" bundle:nil] forCellReuseIdentifier:@"FoundCell"];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundCell"];
    switch (indexPath.row) {
//        case 0:
//        {
//            cell.headImgV.image = [UIImage imageNamed:@"quan"];
//            cell.titleLab.text = @"朋友圈";
//            break;
//        }
        case 0:
        {
            cell.headImgV.image = [UIImage imageNamed:@"sao"];
            cell.titleLab.text = @"扫一扫";
            break;
        }
        case 1:
        {
            cell.headImgV.image = [UIImage imageNamed:@"fj-people"];
            cell.titleLab.text = @"附近的人";
            break;
        }
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
//        case 0:
//        {
//            FriendListController * list = [FriendListController new];
//            [self.navigationController pushViewController:list animated:YES];
//            break;
//        }
        case 0:
        {
            YCProjectScanningController *scanVC = [[YCProjectScanningController alloc]init];
            scanVC.completionHandler = ^(NSString *result) {
                [RCDHTTPTOOL requestFriend:result complete:^(BOOL result) {
                    [YTAlertUtil showTempInfo:@"添加成功"];
                }];
            };
            [self.navigationController pushViewController:scanVC animated:YES];
            break;
        }
        case 1:
        {
            NearManController *nearManVC = [[NearManController alloc]init];
            [self.navigationController pushViewController:nearManVC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
