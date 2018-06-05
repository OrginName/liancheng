//
//  MemberCenterController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MemberCenterController.h"
#import "ProfileHeadView.h"
#import "ProfileCell.h"
#import "YTSideMenuModel.h"
@interface MemberCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@end

@implementation MemberCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
//添加UI
-(void)setUI{
    self.navigationItem.title = @"个人中心";
    ProfileHeadView *tableHeadV = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil][1];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 210 + 64);
    self.tab_Bottom.tableHeaderView = tableHeadV;
}
#pragma mark ---UITableviewDelegate--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][0];
    }
    YTSideMenuModel *model = self.menuModels[indexPath.row];
    cell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    cell.titleLab.text = model.mTitle;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.menuModels[indexPath.row].mClass;
    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc]init];
    if (vc == nil)return;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        NSMutableArray <YTSideMenuModel *> *menuArr = [NSMutableArray array];
        NSArray * menuArray = @[@{@"icon":@"our-fabu",
                                  @"title":@"我的发布",@"class":@"OurSendController"},
                                @{@"icon":@"our-fabu",
                                  @"title":@"我的评价",@"class":@"OurSendController"},
                                @{@"icon":@"our-service",@"title":@"我的服务",@"class":@"OurServiceController"},
                                @{@"icon":@"our-travel",@"title":@"我的旅行",@"class":@"OurServiceController"},
                                @{@"icon":@"our-wanjia",@"title":@"我的玩家",@"class":@"OurPlayController"},
                                @{@"icon":@"our-guanzhu",@"title":@"我的关注",@"class":@"OurConcernController"}];
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            YTSideMenuModel *model = [YTSideMenuModel modelWithDictionary:dic];
            [menuArr addObject:model];
        }];
        _menuModels = menuArr;
    }
    return _menuModels;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tab_Bottom.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
@end
