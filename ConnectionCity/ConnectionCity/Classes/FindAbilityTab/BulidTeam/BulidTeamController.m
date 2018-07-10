//
//  BulidTeamController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//
#import "BulidTeamController.h"
#import "BulidTeamCell.h"
#import "BulidTeamSectionHead.h"
#import "YSButton.h"
#import "TeamChatController.h"
#import "groupMo.h"
#import "RCDGroupInfo.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import "RCDForwardAlertView.h"
#import "CreatGroupController.h"
@interface BulidTeamController ()<BulidTeamSectionHeadDelegate>
{
    BOOL _isOpen[10000]; //== @[NO, NO, NO];
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSourceArr;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@end

@implementation BulidTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self p_initDataSource];
    [self p_initTableView];
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(p_back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data_Arr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //从成员列表中取出 该分组下的成员列表
    NSArray *arr = _data_Arr[section][KString(@"%ld", section+1)];
    //从BOOL数组中取出值进行判断 YES表示开 NO表示合
    if (_isOpen[section]) {
        return arr.count;
    }
    //返回该列表的个数
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BulidTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BulidTeamCell"];
    NSArray *arr = _data_Arr[indexPath.section][KString(@"%ld", indexPath.section+1)];
    groupMo * mo = arr.count!=0?arr[indexPath.row]:[groupMo new];
    cell.titleLab.text = mo.name;
    if ([mo.teamUsers isKindOfClass:[NSArray class]]) {
        cell.peopleNumbersLab.text = KString(@"%lu", (unsigned long)mo.teamUsers.count);
    }else
        cell.peopleNumbersLab.text = @"0";
    [cell.headerImgeView sd_setImageWithURL:[NSURL URLWithString:mo.logo] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TeamChatController *teamChatVC = [[TeamChatController alloc]init];
//    [self.navigationController pushViewController:teamChatVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * arr = _data_Arr[indexPath.section][KString(@"%ld", indexPath.section+1)];
    groupMo * mo = arr.count!=0?arr[indexPath.row]:[groupMo new];
    RCDChatViewController *temp = [[RCDChatViewController alloc] init];
    temp.flagStr = 1;
    temp.targetId = KString(@"team_%@", mo.ID);
    temp.conversationType = ConversationType_GROUP;
    temp.title = [NSString stringWithFormat:@"%@(%@)",mo.name,[mo.teamUsers isKindOfClass:[NSArray class]]?KString(@"%lu", (unsigned long)mo.teamUsers.count):0];
    [self.navigationController pushViewController:temp animated:YES];
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
     headerView.titleLab.text = section==0?@"附近的团队":section==1?@"我的团队":@"加入的团队";
    NSArray *arr = _data_Arr[section][KString(@"%ld", section+1)];
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
    creat.flag_str = 1;
    creat.block = ^{
        [self.data_Arr removeAllObjects];
        [self p_initDataSource];
    };
    [self.navigationController pushViewController:creat animated:YES];
}
#pragma mark - profile method
- (void)p_initDataSource {
    self.data_Arr = [NSMutableArray array];
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableArray * arr1 = [NSMutableArray array];
    NSMutableArray * arr2 = [NSMutableArray array];
    [YSNetworkTool POST:@"/v1/talent/team/relation-to-me/list" params:@{@"areaCode":[KUserDefults objectForKey:kUserCityID]} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        for (int i=0; i<[responseObject[@"data"][@"nearby"] count]; i++) {
            groupMo * mo = [groupMo mj_objectWithKeyValues:responseObject[@"data"][@"nearby"][i]];
            [arr addObject:mo];
        }
        for (int i=0; i<[responseObject[@"data"][@"my"] count]; i++) {
            groupMo * mo = [groupMo mj_objectWithKeyValues:responseObject[@"data"][@"my"][i]];
            [arr1 addObject:mo];
        }
        for (int i=0; i<[responseObject[@"data"][@"join"] count]; i++) {
            groupMo * mo = [groupMo mj_objectWithKeyValues:responseObject[@"data"][@"join"][i]];
            [arr2 addObject:mo];
        }
        [self.data_Arr addObject:@{@"1":arr}];
        [self.data_Arr addObject:@{@"2":arr1}];
        [self.data_Arr addObject:@{@"3":arr2}];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
- (void)p_back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKMAINWINDOW" object:nil];
}
@end
