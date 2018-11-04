//
//  HomeController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "HomeController.h"
#import "ZJScrollPageView.h"
#import "MessageController.h"
#import "EditMenuController.h"
#import "NoticeController.h"
#import "JFCityViewController.h"
#import "HomeNet.h"
#import "MenuMo.h"
#import "TravalController.h"
#import "NewsListController.h"
@interface HomeController ()<JFCityViewControllerDelegate>
{
    BOOL flag;
}
@property (nonatomic,strong)NSMutableArray * myMenuArr;
@end

@implementation HomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    flag = NO;
    self.myMenuArr  = [NSMutableArray array];
    [self initData];
    
}
-(void)initData{
    WeakSelf
    [HomeNet loadMyMeu:^(NSMutableArray *successArrValue) {
        weakSelf.myMenuArr = successArrValue;
        [weakSelf setUI];
    }];
}
-(void)setUI{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    style.titleFont = [UIFont systemFontOfSize:16];
    style.selectedTitleColor = YSColor(249, 145, 0);
    // 设置附加按钮的背景图片
//    style.extraBtnBackgroundImageName = @"our-more";
    style.extraBtnTitleName = @"●●●";
    // 设置子控制器 --- 注意子控制器需要设置title, 将用于对应的tag显示title
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, self.view.bounds.size.height) segmentStyle:style childVcs:childVcs parentViewController:self];
    // 额外的按钮响应的block
    WeakSelf
    scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        flag = NO;
        EditMenuController * edit = [EditMenuController new];
        [weakSelf.navigationController presentViewController:edit animated:YES completion:nil];
    };
    [self.view addSubview:scrollPageView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MyselfClick) image:@"people" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"index-dope" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    self.navigationItem.leftBarButtonItem.badgeValue=self.navigationItem.rightBarButtonItem.badgeValue = @"";
    self.navigationItem.leftBarButtonItem.badgeOriginX = 19;
    self.navigationItem.rightBarButtonItem.badgeOriginX = 29; self.navigationItem.leftBarButtonItem.badgeOriginY = 5;
    self.navigationItem.rightBarButtonItem.badgeOriginY = 2;
    
    //    放置导航栏中间城市选择按钮
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    //    nav_view.backgroundColor = [UIColor redColor];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 25)];
    image.image = [UIImage imageNamed:@"logo"];
    [nav_view addSubview:image];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 60, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"首页" forState:UIControlStateNormal];
    [btn setTitleColor:KFontColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia1"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
}
//城市选择按钮点击
-(void)AddressClick:(UIButton *)btn{
    JFCityViewController * jf= [JFCityViewController new];
    jf.delegate = self;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//导航左按钮我的点击
-(void)MyselfClick{
    flag = NO;
    [self.navigationController pushViewController:[super rotateClass:@"ProfileTwoController"] animated:YES];
}
//导航右侧按钮点击
-(void)MessageClick{
    flag = NO;
    NoticeController * noice = [NoticeController new];
    noice.title = @"消息列表";
    [self.navigationController pushViewController:noice animated:YES];
}
#pragma mark - JFCityViewControllerDelegate
- (void)cityName:(NSString *)name {
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
}
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    UIButton * btn = (UIButton *)[self.navigationItem.titleView viewWithTag:99999];
    [btn setTitle:name forState:UIControlStateNormal];
    
}
-(void)cityMo:(CityMo *)mo{
    
}
- (NSArray *)setupChildVcAndTitle {
    TravalController * trval;
    TravalController * trval2;
    NewsListController * news;
    for (MenuMo * mo in self.myMenuArr) {
        if ([mo.ID isEqualToString:@"1"]) {//旅行
            trval = [TravalController new];
            trval.isInvitOrTrval = YES;
            trval.title = mo.name;
        }else if ([mo.ID isEqualToString:@"2"]){//娱乐
            news = [NewsListController new];
            news.title = @"娱乐";
        }
//        else if ([mo.ID isEqualToString:@"3"]){//生活
//            TravalController * trval = [TravalController new];
//            trval.title = mo.name;
//        }else if ([mo.ID isEqualToString:@"4"]){//圈子
//            TravalController * trval = [TravalController new];
//            trval.title = mo.name;
//        }else if ([mo.ID isEqualToString:@"5"]){//视频
//            TravalController * trval = [TravalController new];
//            trval.title = mo.name;
//        }else if ([mo.ID isEqualToString:@"6"]){//工作
//            TravalController * trval = [TravalController new];
//            trval.title = mo.name;
//        }else if ([mo.ID isEqualToString:@"7"]){//赚外快
//            TravalController * trval = [TravalController new];
//            trval.title = mo.name;
//        }
        else if ([mo.ID isEqualToString:@"8"]){//旅行邀约
            trval2 = [TravalController new];
            trval2.isInvitOrTrval = NO;
            trval2.title = mo.name;
        }
    } 
    NSArray *childVcs = [NSArray arrayWithObjects:trval,news,trval2, nil];
    return childVcs;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden= NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!flag) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setBackgroundImage:
         [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
    }else{
        self.navigationController.navigationBar.hidden= YES;
    }
}
@end