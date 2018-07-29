//
//  WinnerInfoController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "WinnerInfoController.h"
#import "WinnerInfoCell.h"
#import "WinnerInfoHeadView.h"
#import "FirstControllerMo.h"

@interface WinnerInfoController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) WinnerInfoHeadView *tableHeadV;
@property (nonatomic, strong) FirstControllerMo *mo;

@end

@implementation WinnerInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    [self v1TalentTenderDetail];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"中单信息";
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"WinnerInfoCell" bundle:nil] forCellReuseIdentifier:@"WinnerInfoCell"];
    _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"WinnerInfoHeadView" owner:nil options:nil] firstObject];
    _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 180);
    self.tableView.tableHeaderView = _tableHeadV;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WinnerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinnerInfoCell"];
    if (indexPath.row==0) {
        cell.onemodel = self.mo;
    }else{
        cell.twomodel = self.mo;
    }
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
#pragma mark - 接口请求
- (void)v1TalentTenderDetail{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderDetail params:@{@"id": self.bidid} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        FirstControllerMo *model = [FirstControllerMo mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.mo = model;
        weakSelf.tableHeadV.model = model;
        [weakSelf.tableView reloadData];
    } failure:nil];
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
