//
//  MeView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MeView.h"
#import "KissCell.h"
#import "KissModel.h"
#import "KissDetailController.h"
#import "MyTab.h"
@interface MeView ()<UITableViewDataSource,UITableViewDelegate,KissCellDelegate>
@property (nonatomic,strong) UIViewController * controller;
@property (nonatomic, strong) MyTab *tableView;
@property (strong, nonatomic) NSMutableArray *mutDataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger flag;

@end

@implementation MeView
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        self.page = 1;
        self.flag = 0;
        [self addSubview:self.tableView];
        _mutDataArr = [[NSMutableArray alloc]init];
        [self getHeaderData];
        
//        [self addHeaderRefresh];
//        [self addFooterRefresh];
    }
    return self;
}
//- (void)setFrame:(CGRect)frame {
//    self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
//}
#pragma mark -setter & getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            MyTab *tb = [[MyTab alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
            tb.showsVerticalScrollIndicator = NO;
            tb.rowHeight = 160;
            tb.delegate = self;
            tb.dataSource = self;
            tb.backgroundColor = kCommonBGColor;
            tb.tableFooterView = [UIView new];
            tb.separatorStyle = UITableViewCellSeparatorStyleNone;
            //[tb registerClass:[KissCell class] forCellReuseIdentifier:@"KissCell"];
//            [tb registerNib:[UINib nibWithNibName:@"KissCell" bundle:nil] forCellReuseIdentifier:@"KissCell"];
            tb;
        });
    }
    return _tableView;
}
- (void)addHeaderRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshHeaderWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf getHeaderData];
    }];
    [YSRefreshTool beginRefreshingWithView:_tableView];
    self.flag = 1;
}
- (void)addFooterRefresh {
    __weak typeof(self) weakSelf = self;
    [YSRefreshTool addRefreshFooterWithView:self.tableView refreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page ++;
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    //我开通的亲密账户
    WeakSelf
    [YSNetworkTool POST:v1usercloseaccountopenedlist params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.mutDataArr = [KissModel mj_objectArrayWithKeyValuesArray:responseObject[kData][@"accountList"]];
        [weakSelf.tableView reloadData];
    } failure:nil];
}
- (void)getFooterData {

}
- (void)setRefreshStr:(NSString *)refreshStr {
    _refreshStr = refreshStr;
    if (!_flag) {
        [YSRefreshTool beginRefreshingWithView:_tableView];
        _flag = 1;
    }
}
#pragma mark - UITableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutDataArr.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        KissCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KissCell2"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"KissCell" owner:nil options:nil][2];
        }
        return cell;
    }else{
        KissCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KissCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"KissCell" owner:nil options:nil][0];
        }
        cell.flagStr = @"MEVIEW";
        cell.model = _mutDataArr[indexPath.row-1];
        cell.delegate = self;
         return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 133;
    }
    return 170;
}
#pragma mark - KissCellDelegate
- (void)kissCell:(KissCell *)cell deleteBtnClick:(UIButton *)btn {
     
}
- (void)kissCell:(KissCell *)cell sawBtnClick:(UIButton *)btn {
   
    KissDetailController * deltail = [KissDetailController new];
    deltail.title = @"账户详情";
    [self.controller.navigationController pushViewController:deltail animated:YES];
}
@end
