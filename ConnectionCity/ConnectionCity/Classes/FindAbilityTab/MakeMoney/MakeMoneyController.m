//
//  MakeMoneyController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MakeMoneyController.h"
#import "BaseMakeMoneyTabController.h"
#import "BidderController.h"
#import "BountyHostingController.h"
#import "FootprintController.h"
#import "MarginController.h"
#import "WinningBidderController.h"
#import "CustomPage.h"

@interface MakeMoneyController ()

@end

@implementation MakeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    BidderController *messageVC = [[BidderController alloc]init];
    WinningBidderController *addressVC = [[WinningBidderController alloc]init];
    MarginController *lifeVC = [[MarginController alloc]init];
    BountyHostingController *foundVC = [[BountyHostingController alloc]init];
    FootprintController *profileVC = [[FootprintController alloc]init];
    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC,profileVC];
    NSArray *titleArr = @[@"投标人",@"中标人",@"保证金",@"资金托管",@"足迹"];
    NSArray *picArr = @[@"Tendering5-5",@"Tendering4-4",@"Tendering3-3",@"Tendering2-2",@"Tendering1-1"];
    NSArray *picSelectArr = @[@"Tendering5",@"Tendering4",@"Tendering3",@"Tendering2",@"Tendering1"];
    CustomPage *custom = [[CustomPage alloc]initSegmentWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titlesArray:titleArr withSelectArr:picArr withDeSlectArr:picSelectArr vcOrviews:arrVC];
    [self.view addSubview:custom];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    //    BaseMakeMoneyTabController *tbVC = [[BaseMakeMoneyTabController alloc]init];
    //    kWindow.rootViewController = tbVC;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

