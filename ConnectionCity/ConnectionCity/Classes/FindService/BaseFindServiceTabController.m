//
//  BaseMakeMoneyTabController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseFindServiceTabController.h"
#import "ServiceHomeController.h"
#import "TravalController.h"
#import "ServiceStationController.h"
#import "FriendCircleController.h"
#import "ProfileServiceController.h"
@interface BaseFindServiceTabController ()<UITabBarControllerDelegate>

@end
@implementation BaseFindServiceTabController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addItems];
    [self changeItemTextColourAndFont];
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)addItems {
    ServiceHomeController *messageVC = [[ServiceHomeController alloc]init];
    TravalController *addressVC = [[TravalController alloc]init];
    ServiceStationController *lifeVC = [[ServiceStationController alloc]init];
    FriendCircleController *foundVC = [[FriendCircleController alloc]init];
    ProfileServiceController *Profile = [[ProfileServiceController alloc]init];
    
    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC,Profile];
    NSArray *titleArr = @[@"首页",@"旅行",@"服务站",@"圈子",@"我的"];
    NSArray *picArr = @[@"index-nav",@"nav-travel",@"nav-service",@"nav-quan",@"nav-our-service"];
    NSArray *picSelectArr = @[@"index-nav1",@"nav-travel-h",@"nav-service-h",@"nav-quan-h",@"nav-our-service-h"];
    
    for (int i = 0; i < arrVC.count; i++) {
        [self addChildViewController:arrVC[i] title:titleArr[i] image:picArr[i] selectedImage:picSelectArr[i]];
    }
}
#pragma mark --添加子控制器
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:baseNav];
}
#pragma mark --调整item的文字颜色和字体大小
-(void)changeItemTextColourAndFont {
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor hexColorWithString:@"#282828"],NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:YSColor(252, 144, 0),NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateSelected];
}
#pragma mark - UITabBarControllerDelegate
//禁止tab多次点击
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;
    if([tbselect isEqual:viewController]){
        return NO;
    }
    return YES;
}


@end

