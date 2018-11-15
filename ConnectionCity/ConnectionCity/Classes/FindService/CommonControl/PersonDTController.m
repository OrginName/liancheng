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
@interface PersonDTController ()
@end

@implementation PersonDTController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人动态";
    
}
-(void)setUI1{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    //    configration.headerViewScaleMode = YNPageHeaderViewScaleModeCenter;
    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = true;
    configration.showBottomLine = YES;
    
    return [self suspendCenterPageVCWithConfig:configration];
}
-(YNSuspendCenterPageVC *)suspendCenterPageVCWithConfig:(YNPageConfigration *)config {
    
    YNSuspendCenterPageVC *vc = [YNSuspendCenterPageVC pageViewControllerWithControllers:[self getArrayVCs]
                                                                                  titles:[self getArrayTitles]
                                                                                  config:config];
    vc.dataSource = vc;
    vc.delegate = vc;
    /// 轮播图
    SDCycleScrollView *autoScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) imageURLStringsGroup:vc.imagesURLs];
    autoScrollView.delegate = vc;
    
    vc.headerView = autoScrollView;
    /// 指定默认选择index 页面
    vc.pageIndex = 2;
    
    return vc;
}

-(void)setUI{
    //    //必要的设置, 如果没有设置可能导致内容显示不正常
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
     // 显示附加的按钮
    style.showExtraButton = NO;
    style.scrollTitle = NO;
    style.scaleTitle = NO;
    style.titleFont = [UIFont systemFontOfSize:18];
    style.selectedTitleColor = YSColor(249, 145, 0);
    // 设置附加按钮的背景图片
    //    style.extraBtnBackgroundImageName = @"our-more";
     // 设置子控制器 --- 注意子控制器需要设置title, 将用于对应的tag显示title
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 250,kScreenWidth, kScreenHeight-324) segmentStyle:style childVcs:childVcs parentViewController:self];
    scrollPageView.Index = ^(NSInteger currentIndex) {
        NSLog(@"当前index为：%ld",currentIndex);
        
    };
    [self.view addSubview:scrollPageView];
}
- (NSArray *)setupChildVcAndTitle {
    TravalController * controll = [TravalController new];
    controll.isInvitOrTrval = YES;
    controll.title = @"旅行";
    
    UIViewController * controll1 = [UIViewController new];
    controll1.view.backgroundColor = [UIColor yellowColor];
    controll1.title = @"娱乐";
    
    UIViewController * controll2 = [UIViewController new];
    controll2.view.backgroundColor = [UIColor blueColor];
    controll2.title = @"生活";
    
    UIViewController * controll3 = [UIViewController new];
    controll3.view.backgroundColor = [UIColor cyanColor];
    controll3.title = @"圈子";
    
    UIViewController * controll4 = [UIViewController new];
    controll4.view.backgroundColor = [UIColor yellowColor];
    controll4.title = @"视频";
    
    return [NSArray arrayWithObjects:controll,controll1,controll2,controll3,controll4, nil];
}
@end
