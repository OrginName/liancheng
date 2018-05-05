//
//  BaseTabBarController.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "MessageController.h"
#import "AddressBookController.h"
#import "LifeHallController.h"
#import "FoundController.h"
#import "ProfileController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addItems];
    [self changeItemTextColourAndFont];
    self.delegate = self;

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)addItems {
    MessageController *messageVC = [[MessageController alloc]init];
    AddressBookController *addressVC = [[AddressBookController alloc]init];
    LifeHallController *lifeVC = [[LifeHallController alloc]init];
    FoundController *foundVC = [[FoundController alloc]init];
    ProfileController *profileVC = [[ProfileController alloc]init];

    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC,profileVC];
    NSArray *titleArr = @[@"消息",@"通讯录",@"生活馆",@"发现",@"我的"];
    NSArray *picArr = @[@"ic_page_main_2",@"ic_page_data_2",@"ic_page_person_2",@"ic_page_person_2",@"ic_page_person_2"];
    NSArray *picSelectArr = @[@"ic_page_main",@"ic_page_data",@"ic_page_person",@"ic_page_person",@"ic_page_person"];

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
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];

    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kMainGreenColor,NSFontAttributeName:[UIFont systemFontOfSize:12.0]} forState:UIControlStateSelected];
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
