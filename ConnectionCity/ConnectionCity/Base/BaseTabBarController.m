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
#import <RongIMKit/RongIMKit.h>
#import "RCDContactViewController.h"
@interface BaseTabBarController ()<UITabBarControllerDelegate>
@property NSUInteger previousIndex;
@end

@implementation BaseTabBarController
+ (BaseTabBarController *)shareInstance {
    static BaseTabBarController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addItems];
    [self changeItemTextColourAndFont];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSelectedIndex:)
                                                 name:@"ChangeTabBarIndex"
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewControllers
     enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
         if ([obj isKindOfClass:[AddressBookController class]]) {
             AddressBookController *chatListVC = (AddressBookController *)obj;
             [chatListVC updateBadgeValueForTabBarItem];
         }
     }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)addItems {
    MessageController *messageVC = [[MessageController alloc]init];
    AddressBookController *addressVC = [[AddressBookController alloc]init];
    RCDContactViewController *lifeVC = [[RCDContactViewController alloc]init];
    FoundController *foundVC = [[FoundController alloc]init];
    ProfileController *profileVC = [[ProfileController alloc]init];

    NSArray *arrVC = @[messageVC,addressVC,lifeVC,foundVC,profileVC];
    NSArray *titleArr = @[@"首页",@"消息",@"通讯录",@"发现",@"我的"];
    NSArray *picArr = @[@"index-nav",@"nav-new",@"nav-tel",@"nav-fond",@"nav-our"];
    NSArray *picSelectArr = @[@"index-nav1",@"nav-new1",@"nav-tel1",@"nav-fond1",@"nav-our1"];

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
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    NSUInteger index = tabBarController.selectedIndex;
    [BaseTabBarController shareInstance].selectedTabBarIndex = index;
    switch (index) {
        case 0: {
            if (self.previousIndex == index) {
                //判断如果有未读数存在，发出定位到未读数会话的通知
                if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoNextCoversation" object:nil];
                }
                self.previousIndex = index;
            }
            self.previousIndex = index;
        } break;
            
        case 1:
            self.previousIndex = index;
            break;
            
        case 2:
            self.previousIndex = index;
            break;
            
        case 3:
            self.previousIndex = index;
            break;
            
        default:
            break;
    }
}

- (void)changeSelectedIndex:(NSNotification *)notify {
    NSInteger index = [notify.object integerValue];
    self.selectedIndex = index;
}

@end
