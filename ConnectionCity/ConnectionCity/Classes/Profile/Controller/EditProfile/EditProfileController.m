//
//  EditProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditProfileController.h"
#import "EditProfileCell.h"
#import "EditProfileHeadView.h"
#import "EditAllController.h"

@interface EditProfileController ()<EditProfileHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleDataArr;
@property (nonatomic, strong) NSMutableArray *contentDataArr;

@end

@implementation EditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
- (void)setUI {
    self.navigationItem.title = @"基础资料";
}
- (void)setupTableView {
    [self registerCell];
}
- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"EditProfileCell" bundle:nil] forCellReuseIdentifier:@"EditProfileCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    EditProfileHeadView *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"EditProfileHeadView" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 220 + 64);
    tableHeadV.delegate = self;
    self.tableView.tableHeaderView = tableHeadV;
}
#pragma mark - setter and getter
- (NSArray *)titleDataArr{
    if (!_titleDataArr) {
        _titleDataArr = @[@[@"昵称",@"姓名",@"年龄",@"性别",@"所在地区"],@[@"身高",@"体重",@"婚姻",@"学历",@"签名"]];
    }
    return _titleDataArr;
}
- (NSMutableArray *)contentDataArr {
    if (!_contentDataArr) {
        NSMutableArray *firstMutArr = [[NSMutableArray alloc]initWithArray:@[@"东方奇迹",@"江小白",@"18",@"女",@"武汉"]];
        NSMutableArray *secondMutArr = [[NSMutableArray alloc]initWithArray:@[@"160",@"45",@"未婚",@"研究生",@"我是单身贵族"]];
        _contentDataArr = [[NSMutableArray alloc]initWithArray:@[firstMutArr,secondMutArr]];
    }
    return _contentDataArr;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleDataArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleDataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditProfileCell *editProfileCell = [tableView dequeueReusableCellWithIdentifier:@"EditProfileCell"];
    editProfileCell.titleLab.text = self.titleDataArr[indexPath.section][indexPath.row];
    editProfileCell.contentLab.text = self.contentDataArr[indexPath.section][indexPath.row];
    return editProfileCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        if (headerView.subviews.count == 1) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            lab.text = @"以下内容选填，完善后更引人注目";
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = [UIColor orangeColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
        }
    }else{
        return nil;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditAllController * edit = [EditAllController new];
    WeakSelf
    edit.block = ^(NSString * str){
        weakSelf.contentDataArr[indexPath.section][indexPath.row] = str;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:edit animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44;
    }else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }else{
        return 0.1;
    }
}
#pragma mark - EditProfileHeadViewDelegate
- (void)profileHeadView:(EditProfileHeadView *)view photoBtnClick:(UIButton *)btn {
    
}
- (void)profileHeadView:(EditProfileHeadView *)view refreshBtnClick:(UIButton *)btn {
    
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
