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
#import "ConnectionController.h"
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
    return 3;
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
        case 2:
        {
            cell.headImgV.image = [UIImage imageNamed:@"ren"];
            cell.titleLab.text = @"人脉";
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
                 
                    [RCDHTTPTOOL requestFriend:[result componentsSeparatedByString:@"_"][0] complete:^(BOOL result) {
                        [YTAlertUtil showTempInfo:@"申请已发送"];
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
        case 2:
        {
            ConnectionController *nearManVC = [[ConnectionController alloc]init];
            nearManVC.title = @"人脉";
            [self.navigationController pushViewController:nearManVC animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
