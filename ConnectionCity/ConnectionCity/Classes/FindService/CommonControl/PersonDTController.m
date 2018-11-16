//
//  PersonDTController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/14.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonDTController.h"
#import "ZJScrollPageView.h"
#import "TravalController.h"
#import "NewsListController.h"
#import "FriendCircleController.h"
#import <YNPageConfigration.h>
#import "YLController.h"
#import "PersonDTView.h"
#import "PersonNet.h"
#import "YSAccountTool.h"
#import "privateUserInfoModel.h"
#import "NewsController.h"
static NSDictionary * dicNew;
@interface PersonDTController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
//@property (nonatomic,strong)NSDictionary * dic;
@end

@implementation PersonDTController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人动态";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"" title:@"私信" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}
-(void)MessageClick{
    [YTAlertUtil showTempInfo:@"私信"];
} 
+ (instancetype)suspendCenterPageVC:(NSDictionary *)dic{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showBottomLine = YES;
    configration.showNavigation = YES;
    configration.showScrollLine = NO;
    configration.bottomLineHeight = 1;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.bottomLineBgColor = YSColor(241, 242, 243);
    configration.lineWidthEqualFontWidth = true;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.itemFont = configration.selectedItemFont = [UIFont systemFontOfSize:18];
    configration.normalItemColor = [UIColor blackColor];
    configration.selectedItemColor = YSColor(249, 145, 0);
    return [self suspendCenterPageVCWithConfig:configration dic:dic];
}
+ (instancetype)suspendCenterPageVCWithConfig:(YNPageConfigration *)config dic:(NSDictionary *)dic{
    dicNew = dic;
    PersonDTController *vc = [PersonDTController pageViewControllerWithControllers:[self getArrayVCs]
                                                                                  titles:[self getArrayTitles]
                                                                                  config:config];
    vc.dataSource = vc;
    vc.delegate = vc;
    PersonDTView * dtView = [[NSBundle mainBundle] loadNibNamed:@"PersonDTView" owner:nil options:nil][0];
    dtView.frame = CGRectMake(0, 0, kScreenWidth, 263);
    dtView.receiveDic = dic;
    vc.headerView = dtView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    return vc;
}
+ (NSArray *)getArrayVCs {
    YLController * controll = [YLController new];
    controll.userID = dicNew[kData][@"user"][@"id"];
    NewsController * controll1 = [NewsController new];
    controll1.userID = dicNew[kData][@"user"][@"id"];
    YLController * controll2 = [YLController new];
    controll2.userID = dicNew[kData][@"user"][@"id"];
    YLController * controll3 = [YLController new];
    controll3.userID = dicNew[kData][@"user"][@"id"];
    YLController * controll4 = [YLController new];
    controll4.userID = dicNew[kData][@"user"][@"id"];
    return @[controll, controll1, controll2,controll3,controll4];
}

+ (NSArray *)getArrayTitles {
    return @[@"旅行", @"娱乐", @"生活", @"圈子", @"视频"];
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[YLController class]]) {
        return [(YLController *)vc bollec_bottom];
    } else if ([vc isKindOfClass:[NewsController class]]){
        return [(NewsController *)vc tab_Bottom];
    }
    return vc;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}
- (void)pageViewController:(YNPageViewController *)pageViewController didScrollMenuItem:(UIButton *)itemButton index:(NSInteger)index {
    NSLog(@"didScrollMenuItem index %ld", index);
}
@end
