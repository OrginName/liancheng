//
//  BaseNavigationController.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航背景颜色
//    self.navigationBar.barTintColor = kMainGreenColor;
    //隐藏导航条
    //self.navigationBarHidden = YES;
    //设置导航标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];  
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
     
    //隐藏导航返回字体
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES ;
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem  itemWithTarget:self action:@selector(back) image:@"" title:@"返回" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//        viewController.automaticallyAdjustsScrollViewInsets = NO ;
    }
    [super pushViewController:viewController animated:YES];
}
 
-(void)back{
    
}
//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
