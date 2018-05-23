//
//  ReleaseTenderController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ReleaseTenderController.h"
#import "ReleaseTenderCell.h"
#import "ReleaseTenderAdditionalCell.h"

@interface ReleaseTenderController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 发票cell title数据源数组 */
@property (nonatomic, copy) NSArray<NSString *> *cellTitles;
/** 发票cell TextField placeHold数据源数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *cellPlaceHolds;

@end

@implementation ReleaseTenderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.title = @"发布招标";
    _cellTitles = @[@"项目标题", @"项目单位", @"招标所在地", @"开标地点", @"招标内容", @"",@"报名/投标时间",@"投标截止时间",@"招标金额",@"联系人",@"联系电话"];
    _cellPlaceHolds = [NSMutableArray arrayWithArray:@[@"简单描述招标需求", @"海通物业管理有限公司", @"点选择所在地", @"线上", @"填写招标内容",@"", @"选择开始时间",@"选择截止间",@"填写金额 万元",@"填写联系人姓名",@"填写联系电话"]];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReleaseTenderAdditionalCell" bundle:nil] forCellReuseIdentifier:@"ReleaseTenderAdditionalCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(38, 9, kScreenWidth - 38*2, 50 - 9*2);
    btn.layer.cornerRadius = 3;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:YSColor(236,95,90)];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReleaseTenderCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderCell"];
    ReleaseTenderCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ReleaseTenderAdditionalCell"];
    if (indexPath.row == 5) {
        return cell2;
    }else{
        cell1.titleLab.text = _cellTitles[indexPath.row];
        cell1.detailLab.text = _cellPlaceHolds[indexPath.row];
        return cell1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 165;
    }else{
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        if (headerView.subviews.count == 1) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            lab.text = @"最多上传3个,每个不超过10M,支持jpg,png,gif格式";
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = [UIColor darkGrayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:lab];
        }
    }
    return headerView;
}
#pragma mark - 点击事件
- (void)nextBtnClick:(UIButton *)btn {
    
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
