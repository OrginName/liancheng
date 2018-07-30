//
//  PresentManageViewController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PresentManageViewController.h"
#import "PresentCell.h"

@interface PresentManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation PresentManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addHeaderRefresh];
    //[self addFooterRefresh];
}
-(void)setUI{
    self.navigationItem.title = @"提现管理";
    self.dataArr = [[NSMutableArray alloc]init];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *itemArr = _dataArr[section];
    return itemArr.count + 1;
//    if (section==0) {
//        return _dataArr.count + 1;
//    }else{
//        return 2;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = YSColor(241, 241, 241);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PresentCell * cell = [PresentCell tempTableViewCellWith:tableView indexPath:indexPath];
    
//    if (indexPath.section ==0 && indexPath.row>0) {
//        cell.model = _dataArr[indexPath.row - 1];
//    }
    if (indexPath.row>0) {
        NSArray *itemArr = _dataArr[indexPath.section];
        cell.model = itemArr[indexPath.row - 1];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.accountBlock) {
        if (indexPath.row>0) {
            NSArray *itemArr = _dataArr[indexPath.section];
            AccountPageMo *mo = itemArr[indexPath.row - 1];
            self.accountBlock(mo);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (IBAction)AccountClick:(UIButton *)sender {
    [self.navigationController pushViewController:[super rotateClass:@"BindingController"] animated:YES];
}
#pragma mark - 接口请求
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshHeaderWithView:self.tab_Bottom refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf getHeaderData];
    }];
    [YSRefreshTool beginRefreshingWithView:self.tab_Bottom];
}
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshFooterWithView:self.tab_Bottom refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page ++;
        //[strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"100"
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1UserWalletWithdrawAccountPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        NSMutableArray *oneArr = [NSMutableArray new];
        NSMutableArray *twoArr = [NSMutableArray new];
        NSMutableArray *threeArr = [NSMutableArray new];
        for (AccountPageMo *mo in [AccountPageMo mj_objectArrayWithKeyValuesArray:responseObject[kData]]) {
            if ([mo.accountType isEqualToString:@"银行卡"]) {
                [oneArr addObject:mo];
            }else if([mo.accountType isEqualToString:@"微信"]) {
                [twoArr addObject:mo];
            }else if ([mo.accountType isEqualToString:@"支付宝"]){
                [threeArr addObject:mo];
            }
        }
        [weakSelf.dataArr addObjectsFromArray:@[oneArr,twoArr,threeArr]];
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}
- (void)getFooterData {
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10"
                          };
    
    WeakSelf
    [YSNetworkTool POST:v1UserWalletWithdrawAccountPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (AccountPageMo *mo in [AccountPageMo mj_objectArrayWithKeyValuesArray:responseObject[kData]]) {
            [weakSelf.dataArr addObject:mo];
        }
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}
@end


