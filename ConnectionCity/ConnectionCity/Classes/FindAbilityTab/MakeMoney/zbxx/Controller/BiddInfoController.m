//
//  BiddInfoController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BiddInfoController.h"
#import "BiddInfoCell.h"
#import "BiddInfoHeadView.h"

@interface BiddInfoController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation BiddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setData {
    _titleArr = @[@"招标金额",@"报名/投标时间",@"报名/投标截止时间",@"联系人",@"联系电话"];
    _dataArr = @[@"10,000.00",@"2018-06-10",@"2018-07-10",@"刘永富",@"18865657799"];
}
- (void)setUI {
    self.navigationItem.title = @"招标信息";
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BiddInfoCell" bundle:nil] forCellReuseIdentifier:@"BiddInfoCell"];
    BiddInfoHeadView *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"BiddInfoHeadView" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 565 + 64);
    self.tableView.tableHeaderView = tableHeadV;
    UIView *tableFootV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    tableFootV.backgroundColor = kCommonBGColor;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [tableFootV addSubview:bgView];
    UIButton *bidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bidBtn.layer.cornerRadius = 3;
    [bidBtn setTitle:@"投标" forState: UIControlStateNormal];
    [bidBtn setBackgroundColor:YSColor(236,95,90)];
    [bgView addSubview:bidBtn];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    [bidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.bottom.mas_equalTo(-9);
    }];
    self.tableView.tableFooterView = tableFootV;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BiddInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BiddInfoCell"];
    cell.titleLab.text = _titleArr[indexPath.row];
    cell.detailnfoLab.text = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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
