//
//  BaseMakeMoneyTabController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseChangeTabController.h"
#import "ChangePlayController.h"
#import "PlayPoductController.h"
#import "SwapController.h"
#import "EnthusiastsControll.h"
@interface BaseChangeTabController ()<UITabBarControllerDelegate>

@end
@implementation BaseChangeTabController
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
    ChangePlayController *messageVC = [[ChangePlayController alloc]init];
    SwapController *addressVC = [[SwapController alloc]init];
    EnthusiastsControll *lifeVC = [[EnthusiastsControll alloc]init];
    PlayPoductController *foundVC = [[PlayPoductController alloc]init];
    
    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC];
    NSArray *titleArr = @[@"首页",@"互换身份",@"发烧友",@"玩品柜"];
    NSArray *picArr = @[@"index-nav",@"nav-our-service",@"ch-people",@"ch-guizi"];
    NSArray *picSelectArr = @[@"index-nav1",@"nav-our-service-h",@"ch-people-h",@"ch-guizi-h"];
    
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
