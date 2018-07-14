//
//  TravalController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TravalController.h"
#import "CustomButton.h"
#import "TrvalCell.h"
#import "TrvalTrip.h"
#import "FilterOneController.h"
#import "JFCityViewController.h"
#import "ServiceHomeNet.h"
#import "TrvalInvitController.h"
#import "SendTripController.h"
#import "RCDChatViewController.h"
@interface TravalController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate>
{
    UIButton * _tmpBtn;
    NSInteger  _page;
    NSString * _cityID;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_PYYY;
@property (nonatomic,strong)TrvalTrip * trval;
@property (weak, nonatomic) IBOutlet UIButton *btn_travl;
@property (weak, nonatomic) IBOutlet UIButton *btn_invit;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (weak, nonatomic) IBOutlet UIView *view_tab;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@end
@implementation TravalController
- (void)viewDidLoad {
    [super viewDidLoad];
     _page=1;
//    [KUserDefults objectForKey:kUserCityID]
    _cityID = @"";
    [self setUI];
    [self initData];
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self requstLoad:@{@"cityID":_cityID}];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad:@{@"cityID":_cityID}];
    }];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)requstLoad:(NSDictionary *) dic{
    NSDictionary * dic1 = @{
                           @"age": dic[@"age"]?dic[@"age"]:@"",
                           @"cityCode": dic[@"cityID"],
                           @"distance": dic[@"distance"]?dic[@"distance"]:@"",
                           @"gender": dic[@"gender"]?dic[@"gender"]:@"",
                           @"lat": @([[KUserDefults objectForKey:kLat]floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng]floatValue]),
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           @"userStatus": dic[@"userStatus"]?dic[@"userStatus"]:@"",
                           @"validType": dic[@"validType"]?dic[@"validType"]:@""
                           };
    [ServiceHomeNet requstTrvalDic:dic1 withSuc:^(NSMutableArray *successArrValue){
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self.tab_Bottom.mj_header endRefreshing];
        [self.tab_Bottom.mj_footer endRefreshing];
        [self.data_Arr addObjectsFromArray:successArrValue];
        [self.tab_Bottom reloadData];
    }];
}
#pragma mark ---按钮点击事件-----
//筛选
-(void)SearchClick{
    FilterOneController * filter = [FilterOneController new];
    filter.title = @"筛选条件";
    filter.flag_SX = 1;
    filter.block = ^(NSDictionary *strDic) {
        self.trval.dic = strDic;
        [self requstLoad:@{
                         @"cityID":_cityID,
                         @"age":strDic[@"0"],
                         @"distance":strDic[@"1"],
                         @"gender":strDic[@"2"],
                         @"userStatus":strDic[@"10"],
                         @"validType":strDic[@"3"]
                         }];
    };
    [self.navigationController pushViewController:filter animated:YES];
}
- (IBAction)send_invit:(UIButton *)sender {
    NSString * str = @"";
    if ([sender.titleLabel.text isEqualToString:@"发布陪游"]) {
        str = @"SendTripController";
    } else {
        str = @"TrvalInvitController";
    }
    UIViewController * controller = [super rotateClass:str];
    if ([controller isKindOfClass:[TrvalInvitController class]]) {
        TrvalInvitController * invit = (TrvalInvitController *)controller;
        invit.block = ^{
            [self.tab_Bottom.mj_header beginRefreshing];
        };
    }
    if ([controller isKindOfClass:[SendTripController class]]) {
        SendTripController * invit = (SendTripController *)controller;
        invit.block = ^{
            [self.trval.bollec_bottom.mj_header beginRefreshing];
        };
    }
    [self.navigationController pushViewController:controller animated:YES];
}
//城市更改
-(void)CityClick{
    JFCityViewController * jf= [JFCityViewController new];
    jf.delegate = self;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:jf];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//获取当前选取的城市model
#pragma mark --- JFCityViewControllerDelegate-----
-(void)city:(NSString *)name ID:(NSString *)ID lat:(NSString *)lat lng:(NSString *)lng{
    [self loadData:ID name:name];
    _cityID = ID;
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)cityMo:(CityMo *)mo{
    [self loadData:mo.ID name:mo.name];
    _cityID = mo.ID;
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)loadData:(NSString *)ID name:(NSString *)name{
    [self.backBtn setTitle:name forState:UIControlStateNormal];
    [self.data_Arr removeAllObjects];
    _cityID = ID;
    _page = 1;
    [self.tab_Bottom.mj_header beginRefreshing];
    self.trval.page=1;
    self.trval.cityID = ID;
    [self.trval.data_Arr removeAllObjects];
    [self.trval.bollec_bottom.mj_header beginRefreshing];
}
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}
//添加UI
-(void)setUI{
    [super setFlag_back:YES];//设置返回按钮
    self.btn_invit.layer.borderColor = YSColor(246, 207, 174).CGColor;
    self.btn_invit.layer.borderWidth = 2;
    TrvalCell * cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][1];
    self.tab_Bottom.tableHeaderView = cell;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"筛选" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:self.trval];
    [self initLeftBarButton];
}
-(void)initLeftBarButton{
    //为导航栏添加右侧按钮1
    UIBarButtonItem * left1 = [UIBarButtonItem itemWithRectTarget:self action:@selector(back) image:@"return-f" title:@"" withRect:CGRectMake(0, 0, 30, 10)];
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:[KUserDefults objectForKey:kUserCity] forState:UIControlStateNormal];
    self.backBtn = btn;
    [btn addTarget:self action:@selector(CityClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"s-xiala"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, -7, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    NSArray *  arr = @[left1,right2];
    self.navigationItem.leftBarButtonItems = arr;
}
#pragma mark ---- UITableviewDelegate------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data_Arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TrvalCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][0];
    }
    cell.receive_Mo = self.data_Arr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    NSString *title,*ID,*name;
    trvalMo * mo = self.data_Arr[indexPath.row];
    ID = [mo.user1.ID description];
    name = mo.user1.nickName;
    chatViewController.targetId = ID;
    if ([ID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        title = [RCIM sharedRCIM].currentUserInfo.name;
    } else {
        title = name;
    }
    chatViewController.title = title;
    chatViewController.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.layer.borderWidth = 2;
    _tmpBtn.layer.borderWidth = 2;
    if (sender.tag==1) {
        self.btn_invit.selected = NO;
        self.btn_invit.layer.borderColor = [UIColor clearColor].CGColor;
        self.tab_Bottom.hidden = YES;
        self.trval.hidden = NO;
        [self.btn_PYYY setTitle:@"发布陪游" forState:UIControlStateNormal];
    }else{
        self.tab_Bottom.hidden = NO;
        self.trval.hidden = YES;
        [self.btn_PYYY setTitle:@"发布邀约" forState:UIControlStateNormal];
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        sender.layer.borderColor = YSColor(246, 207, 174).CGColor;
        _tmpBtn = sender;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
        sender.layer.borderColor = YSColor(246, 207, 174).CGColor;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        _tmpBtn.layer.borderColor = [UIColor clearColor].CGColor;
        sender.selected = YES;
        sender.layer.borderColor = YSColor(246, 207, 174).CGColor;
        _tmpBtn = sender;
    }
    
}
-(TrvalTrip *)trval{
    if (!_trval) {
        _trval = [[TrvalTrip alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth-20, kScreenHeight-260) withControl:self];
        _trval.hidden = YES;
    }
    return _trval;
}

@end
