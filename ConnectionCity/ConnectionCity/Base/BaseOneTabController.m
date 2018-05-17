//
//  BaseOneTabController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseOneTabController.h"
#import "BaseNavigationController.h"
#import "AbilityHomeController.h"
#import "AddressBookController.h"
#import "BulidTeamController.h"
#import "MakeMoneyController.h"
#import "ConnectionController.h"

@interface BaseOneTabController ()<UITabBarControllerDelegate>

@end

@implementation BaseOneTabController

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
    AbilityHomeController *messageVC = [[AbilityHomeController alloc]init];
    AddressBookController *addressVC = [[AddressBookController alloc]init];
    BulidTeamController *lifeVC = [[BulidTeamController alloc]init];
    MakeMoneyController *foundVC = [[MakeMoneyController alloc]init];
    ConnectionController *profileVC = [[ConnectionController alloc]init];
    
    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC,profileVC];
    NSArray *titleArr = @[@"首页",@"消息",@"建团队",@"赚外快",@"人脉"];
    NSArray *picArr = @[@"index-nav",@"nav-new1-1",@"nav-t",@"money",@"ren"];
    NSArray *picSelectArr = @[@"index-nav1",@"nav-new1",@"nav-t1",@"money1",@"ren1"];
    
    for (int i = 0; i < 5; i++) {
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
