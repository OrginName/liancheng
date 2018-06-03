//
//  ProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ProfileController.h"
#import "YTSideMenuModel.h"
#import "ProfileCell.h"
#import "ProfileHeadView.h"

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray <YTSideMenuModel *> *menuModels;

@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarClick) image:@"erweima" title:nil EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    ProfileHeadView *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeadView" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 210 + 64);
    self.tableView.tableHeaderView = tableHeadV;
}
#pragma mark - setter and getter
- (NSArray<YTSideMenuModel *> *)menuModels {
    if (_menuModels == nil) {
        NSMutableArray <YTSideMenuModel *> *menuArr = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"MenuIcons" ofType:@"plist"];
        NSArray *menuArray = [NSArray arrayWithContentsOfFile:path];
        [menuArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            YTSideMenuModel *model = [YTSideMenuModel modelWithDictionary:dic];
            [menuArr addObject:model];
        }];
        _menuModels = menuArr;
    }
    return _menuModels;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    YTSideMenuModel *model = self.menuModels[indexPath.row];
    profileCell.iconImgV.image = [UIImage imageNamed:model.mIcon];
    profileCell.titleLab.text = model.mTitle;
    return profileCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 根据类名跳转控制器
//    NSString *className = [YTAccountInfo loginState] ? self.menuModels[indexPath.row].mClass : @"YTLoginViewController";
//    UIViewController *vc = (UIViewController *)[[NSClassFromString(className) alloc]init];
//    if (vc == nil)return;
//    UINavigationController *rootNC = [NSObject yt_getRootNC];
//    [rootNC pushViewController:vc animated:YES];
}

#pragma mark - 点击事件
- (void)rightBarClick {
    
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
