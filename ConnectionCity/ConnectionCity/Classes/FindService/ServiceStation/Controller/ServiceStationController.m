//
//  ServiceStationController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceStationController.h"
#import "BulidTeamCell.h"
#import "BulidTeamSectionHead.h"
#import "YSButton.h"
#import "CreatGroupController.h"
@interface ServiceStationController ()
{
    BOOL _isOpen[10000]; //== @[NO, NO, NO];
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSourceArr;

@end
@implementation ServiceStationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self p_initDataSource];
}
#pragma mark - setup
- (void)setUI {
    [super setFlag_back:YES];//设置返回按钮
    [self p_initTableView];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourceArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //从成员列表中取出 该分组下的成员列表
    NSArray *arr = _dataSourceArr[section];
    //从BOOL数组中取出值进行判断 YES表示开 NO表示合
    if (_isOpen[section]) {
        return arr.count;
    }
    //返回该列表的个数
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BulidTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BulidTeamCell"];
    NSArray *arr = _dataSourceArr[indexPath.section];
    cell.titleLab = arr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    BulidTeamSectionHead *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BulidTeamSectionHead"];
    //设置区头视图代理
    headerView.delegate = self;
    //找按钮
    YSButton *button = (YSButton *)[headerView.contentView viewWithTag:1001];
    //将区号传给按钮绑定方法 扩充属性
    button.tagId = section;
    //找图标
    UIImageView *imageView = (UIImageView *)[headerView.contentView viewWithTag:1000];
    //根据不同区的开合状态设置小三角旋转
    //CGAffineTransformMakeRotation该方法传入弧度
    //CGAffineTransformIdentity设置回归原始位置
    imageView.transform = _isOpen[section]?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformIdentity;
    //设置区头标题
    if (section==0) {
        headerView.titleLab.text = @"我的团队";
    }else{
        headerView.titleLab.text = @"加入的团队";
    }
    NSArray *arr = _dataSourceArr[section];
    headerView.teamNumbers.text = [NSString stringWithFormat:@"%lu",(unsigned long)arr.count];
    //返回区头视图
    return headerView;
}
#pragma mark - BulidTeamSectionHeadDelegate
- (void)bulidTeamSectionHead:(BulidTeamSectionHead *)bulidTeamSectionHead headerButtonClick:(YSButton *)btn {
    //从数组中取出BOOL值进行取反 改变当前区的开合状态
    _isOpen[btn.tagId] = !_isOpen[btn.tagId];
    //刷新表 重新加载表中的数据
    [_tableView reloadData];
}
#pragma mark - response method
//创建团队
- (void)headerBtnClick:(UIButton *)btn {
    CreatGroupController * creat = [CreatGroupController new];
    creat.block = ^{
        
    };
    [self.navigationController pushViewController:creat animated:YES];
}
#pragma mark - profile method
- (void)p_initDataSource {
    self.dataSourceArr = @[@[@"1",@"2",@"3"],@[@"1",@"2",@"3",@"4",@"5"]];
}
- (void)p_initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BulidTeamCell" bundle:nil] forCellReuseIdentifier:@"BulidTeamCell"];
    [self.tableView registerClass:[BulidTeamSectionHead class] forHeaderFooterViewReuseIdentifier:@"BulidTeamSectionHead"];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    headerView.backgroundColor = kCommonBGColor;
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    headerBtn.frame = CGRectMake(0, 10, kScreenWidth, 50);
    headerBtn.backgroundColor = [UIColor whiteColor];
    headerBtn.layer.cornerRadius = 5;
    [headerBtn setTitle:@"  创建团队" forState: UIControlStateNormal];
    [headerBtn setImage:[UIImage imageNamed:@"jia-team"] forState:UIControlStateNormal];
    [headerBtn setTintColor:[UIColor orangeColor]];
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerBtn];
    self.tableView.tableHeaderView = headerView;
}
@end
