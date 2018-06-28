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
#import "FirstController.h"

@interface MakeMoneyController ()<CustomPageDelegate>
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,strong) CustomPage *custom;

@end

@implementation MakeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTabBar];
    _currentIndex = 0;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.custom.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(p_back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}
- (void)setTabBar {
    BidderController *messageVC = [[BidderController alloc]init];
    WinningBidderController *addressVC = [[WinningBidderController alloc]init];
    MarginController *lifeVC = [[MarginController alloc]init];
    BountyHostingController *foundVC = [[BountyHostingController alloc]init];
    FootprintController *profileVC = [FootprintController new];
    FirstController * first = [FirstController new];
    NSArray *arrVC = @[first,messageVC,addressVC,lifeVC,foundVC,profileVC];
    _titleArr = @[@"投标人",@"中标人",@"保证金",@"资金托管",@"足迹"];
    NSArray *picArr = @[@"Tendering5-5",@"Tendering4-4",@"Tendering3-3",@"Tendering2-2",@"Tendering1-1"];
    NSArray *picSelectArr = @[@"Tendering5",@"Tendering4",@"Tendering3",@"Tendering2",@"Tendering1"];
    self.custom = [[CustomPage alloc]initSegmentWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSafeAreaBottomHeight - 64) titlesArray:_titleArr withSelectArr:picSelectArr withDeSlectArr:picArr vcOrviews:arrVC];
    self.custom.delegate = self;
    [self.view addSubview:self.custom];
}
#pragma mark - profile method
-(void)p_back{
    if ([_titleArr containsObject:self.navigationItem.title]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backWhere" object:nil];
        _currentIndex = 0;
        self.navigationItem.title = @"赚外快";
    } else if([self.title  isEqualToString: @"赚外快"]) {
        self.tabBarController.selectedIndex = 0;
        self.custom.hidden = YES;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - CustomPageDelegate
- (void)selectedIndex:(NSInteger)index {
    self.navigationItem.title = _titleArr[index];
    _currentIndex = index;
}
#pragma mark - 接口请求
- (void)v1TalentTenderCreate:(NSDictionary *)dic{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderPage params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确认" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}

@end

