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
#import "FirstControllerMo.h"
#import "AllDicMo.h"
#import "RCDChatViewController.h"
#import "PersonalBasicDataController.h"
#import "UserMo.h"

@interface BiddInfoController ()<BiddInfoHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BiddInfoHeadView *tableHeadV;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) FirstControllerMo *mo;

@end

@implementation BiddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
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
- (void)setData {
    _titleArr = @[@"接单金额",@"报名/抢单时间",@"报名/抢单截止时间",@"联系人",@"联系电话"];
    _dataArr = [NSMutableArray arrayWithArray:@[@"10,000.00",@"2018-06-10",@"2018-07-10",@"刘永富",@"18865657799"]];
}
- (void)setUI {
    self.navigationItem.title = @"接单信息";
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BiddInfoCell" bundle:nil] forCellReuseIdentifier:@"BiddInfoCell"];
    _tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"BiddInfoHeadView" owner:nil options:nil] firstObject];
    _tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 440);
    _tableHeadV.delegate = self;
    self.tableView.tableHeaderView = _tableHeadV;
    UIView *tableFootV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    tableFootV.backgroundColor = kCommonBGColor;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [tableFootV addSubview:bgView];
    UIButton *bidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bidBtn.layer.cornerRadius = 3;
    [bidBtn setTitle:@"抢单" forState: UIControlStateNormal];
    [bidBtn setBackgroundColor:YSColor(236,95,90)];
    [bidBtn addTarget:self action:@selector(bidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark - BiddInfoHeadViewDelegate
- (void)biddInfoHeadView:(BiddInfoHeadView *)view headBtnClick:(UIButton *)btn {
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.connectionMo = _mo.user;
    [self.navigationController pushViewController:person animated:YES];
}
- (void)biddInfoHeadView:(BiddInfoHeadView *)view expandBtnClick:(UIButton *)btn {
    
}
#pragma mark - 点击事件
- (void)bidBtnClick:(UIButton *)btn {
    //[YTAlertUtil showTempInfo:@"抢单"];
    [self v1TalentTenderRecordCreate];
}
- (IBAction)dialogueBtnClick:(id)sender {
//    [YTAlertUtil showTempInfo:@"对话"];
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    NSString *title,*ID,*name;
    ID = self.mo.user.ID;
    name = self.mo.user.nickName;
    chatViewController.targetId = ID;
    if ([ID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        title = [RCIM sharedRCIM].currentUserInfo.name;
    } else {
        title = name;
    }
    chatViewController.title = title;
//        chatViewController.needPopToRootView = YES;
    chatViewController.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
}
- (IBAction)focusOnBtnClick:(id)sender {
    //[YTAlertUtil showTempInfo:@"关注"];
    [self v1CommonFollowCreate];
}
#pragma mark - 接口请求
- (void)v1TalentTenderDetail{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderDetail params:@{@"id": self.bidid} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        FirstControllerMo *model = [FirstControllerMo mj_objectWithKeyValues:responseObject[kData]];
        weakSelf.mo = model;
        weakSelf.tableHeadV.model = model;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.dataArr addObjectsFromArray:@[model.amount?model.amount:@"",model.tenderStartDate?model.tenderStartDate:@"",model.tenderEndDate?model.tenderEndDate:@"",model.contactName?model.contactName:@"",model.contactMobile?model.contactMobile:@""]];
        [weakSelf.tableView reloadData];
    } failure:nil];
}
- (void)v1TalentTenderRecordCreate{
    WeakSelf
    [YSNetworkTool POST:v1TalentTenderRecordCreate params:@{@"tenderId": self.bidid,@"score":@"0"} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
- (void)v1CommonFollowCreate{
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[6] contentArr][0];
    [YSNetworkTool POST:v1CommonFollowCreate params:@{@"typeId":self.bidid,@"type":@([mo.value integerValue]),@"followedUserId":[[YSAccountTool userInfo] modelId]} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil showTempInfo:responseObject[@"message"]];
    } failure:nil];
}
@end
