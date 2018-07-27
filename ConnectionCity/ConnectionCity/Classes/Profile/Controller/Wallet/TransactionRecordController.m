//
//  TransactionRecordController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TransactionRecordController.h"
#import "CustomButton.h"
#import "PresentCell.h"
#import "AllDicMo.h"
#import "QFDatePickerView.h"
#import "TransactionRecordMo.h"
#import "PaymentModel.h"

@interface TransactionRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    CustomButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
@property (weak, nonatomic) IBOutlet CustomButton *btn_All;
@property (weak, nonatomic) IBOutlet UIButton *inandoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedMonceBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tagFlag;

@end

@implementation TransactionRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addHeaderRefresh];
    [self addFooterRefresh];
    self.tagFlag = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    
    [_selectedMonceBtn setTitle:[NSString stringWithFormat:@"%ld-%.2ld",currentYear,currentMonth] forState:UIControlStateNormal];
}
-(void)setUI{
    self.navigationItem.title = @"交易记录";
    self.btn_All.selected = YES;
    _tmpBtn = self.btn_All;
    self.dataArr = [[NSMutableArray alloc]init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PresentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PresentCell2"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PresentCell" owner:nil options:nil][2];
    }
    cell.paymentModel = _dataArr[indexPath.row];
    return cell;
}
- (IBAction)BtnSelectClick:(CustomButton *)sender {
    self.tagFlag = sender.tag - 100;
    if (sender.tag!=1) {
        self.btn_All.selected = NO;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    
    [YSRefreshTool beginRefreshingWithView:self.tab_Bottom];
}
- (IBAction)selectedMonceBtnClick:(id)sender {
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
        [_selectedMonceBtn setTitle:str forState:UIControlStateNormal];
        [YSRefreshTool beginRefreshingWithView:self.tab_Bottom];
    }];
    [datePickerView animateShow];
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
        [strongSelf getFooterData];
    }];
}
- (void)getHeaderData {
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[25] contentArr][self.tagFlag];
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"type": mo.value,
                          @"dMonth":_selectedMonceBtn.titleLabel.text,
                          };
    WeakSelf
    [YSNetworkTool POST:v1UserWalletPaymentPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf.dataArr removeAllObjects];
        TransactionRecordMo *mo = [TransactionRecordMo mj_objectWithKeyValues:responseObject[kData]];
        [weakSelf.dataArr addObjectsFromArray:mo.paymentList];
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
        [weakSelf.inandoutBtn setTitle:[NSString stringWithFormat:@"收入：￥%@  支出：￥%@",mo.totalIncome?mo.totalIncome:@"0.00",mo.totalPay?mo.totalPay:@"0.00"] forState:UIControlStateNormal];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}
- (void)getFooterData {
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[25] contentArr][self.tagFlag];
    NSDictionary *dic = @{
                          @"pageNumber": [NSString stringWithFormat:@"%ld",(long)_page],
                          @"pageSize": @"10",
                          @"type": mo.value,
                          @"dMonth":_selectedMonceBtn.titleLabel.text,
                          };
    WeakSelf
    [YSNetworkTool POST:v1UserWalletPaymentPage params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        TransactionRecordMo *mo = [TransactionRecordMo mj_objectWithKeyValues:responseObject[kData]];
        [weakSelf.dataArr addObjectsFromArray:mo.paymentList];
        [weakSelf.tab_Bottom reloadData];
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YSRefreshTool endRefreshingWithView:self.tab_Bottom];
    }];
}

@end
