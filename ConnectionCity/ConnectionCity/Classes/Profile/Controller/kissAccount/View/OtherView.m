//
//  OtherView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OtherView.h"
#import "KissCell.h"
#import "KissDetailController.h"

@interface OtherView ()<UITableViewDataSource,UITableViewDelegate,KissCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *mutDataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic,strong)  kissAccountController * controller;
@end

@implementation OtherView

- (instancetype)initWithFrame:(CGRect)frame viewController:(kissAccountController *)controller
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
            UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
            tb.showsVerticalScrollIndicator = NO;
            tb.rowHeight = 160;
            tb.delegate = self;
            tb.dataSource = self;
            tb.backgroundColor = [UIColor whiteColor];
            tb.tableFooterView = [UIView new];
            tb.separatorStyle = UITableViewCellSeparatorStyleNone;
            //[tb registerClass:[KissCell class] forCellReuseIdentifier:@"KissCell"];
//            [tb registerNib:[UINib nibWithNibName:@"KissCell" bundle:nil] forCellReuseIdentifier:@"KissCell"];
            UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 170)];
            footerV.backgroundColor = [UIColor whiteColor];
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            addBtn.frame = CGRectMake((footerV.width - 100)/2.0, footerV.center.y - 50, 100, 100);
            [addBtn setBackgroundImage:[UIImage imageNamed:@"jiaMe"] forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [footerV addSubview:addBtn];
            UILabel *addLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(addBtn.frame), footerV.width, 30)];
            addLab.text = @"添加亲密账户";
            addLab.textColor = [UIColor lightGrayColor];
            addLab.textAlignment = NSTextAlignmentCenter;
            [footerV addSubview:addLab];
            tb.tableFooterView = footerV;
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
        strongSelf.page++;
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    //我被开通的亲密账户
    WeakSelf
    [YSNetworkTool POST:v1usercloseaccountlist params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.mutDataArr = [KissModel mj_objectArrayWithKeyValuesArray:responseObject[kData]];
        if (weakSelf.mutDataArr.count!=0) {
            weakSelf.controller.view_QMZH.hidden = YES;
        }
        if (weakSelf.mutDataArr.count==3) {
            [weakSelf.tableView.tableFooterView removeFromSuperview];
            weakSelf.tableView.tableFooterView.height = 0;
        }
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
    return _mutDataArr.count==0?1:_mutDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mutDataArr.count!=0) {
        KissCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KissCell0"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"KissCell" owner:nil options:nil][0];
        }
        cell.model = _mutDataArr[indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
       KissCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KissCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"KissCell" owner:nil options:nil][1];
        }
       return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mutDataArr.count!=0){
        return 170;
    }
    return kScreenHeight-270-64-20;
}
#pragma mark - KissCellDelegate
- (void)kissCell:(KissCell *)cell deleteBtnClick:(UIButton *)btn {
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    KissModel * model = _mutDataArr[index.row];
    WeakSelf
    [YTAlertUtil alertDualWithTitle:@"连程" message:KString(@"您即将解除亲密账户%@", model.closeUserId) style:UIAlertControllerStyleAlert cancelTitle:@"否" cancelHandler:^(UIAlertAction *action) {
        
    } defaultTitle:@"是" defaultHandler:^(UIAlertAction *action) {
        [YSNetworkTool POST:v1usercloseaccountdelete params:@{@"id":model.modelId} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf getHeaderData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } completion:nil];
}
- (void)kissCell:(KissCell *)cell sawBtnClick:(UIButton *)btn {
    NSIndexPath * index  = [self.tableView indexPathForCell:cell];
    KissDetailController * deltail = [KissDetailController new];
    deltail.title = @"账户详情";
    deltail.modelReceive = _mutDataArr[index.row];
    [self.controller.navigationController pushViewController:deltail animated:YES];
}
#pragma mark - 点击事件
- (void)addBtnClick:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(otherView:addBtn:)]) {
        [_delegate otherView:self addBtn:btn];
    }
}
@end
