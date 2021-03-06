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
 #import "FilterOneController.h"
#import "JFCityViewController.h"
#import "ServiceHomeNet.h"
#import "TrvalInvitController.h"
#import "SendTripController.h"
#import "RCDChatViewController.h"
#import "UIView+Geometry.h"
#import "PersonalBasicDataController.h"
#import "privateUserInfoModel.h"
@interface TravalController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate,TrvalCellDelegate>
{
    UIButton * _tmpBtn;
    NSString * _cityID;
}
@property (weak, nonatomic) IBOutlet UIView *btnView1;
@property (weak, nonatomic) IBOutlet UIButton *btn_PYYY;
@property (weak, nonatomic) IBOutlet UIButton *btn_travl;
@property (weak, nonatomic) IBOutlet UIButton *btn_invit;
@property (weak, nonatomic) IBOutlet UIView *view_tab;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,strong) UIView * btnView;
@end
@implementation TravalController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (@available(iOS 11.0, *)) {
//        self.tab_Bottom.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
//        self.tab_Bottom.contentInset =UIEdgeInsetsMake(0,0,0,0);//64和49自己看效果，是否应该改成0
//        self.tab_Bottom.scrollIndicatorInsets = self.tab_Bottom.contentInset;
//    }
    self.tab_Bottom.estimatedRowHeight = 0;
    self.tab_Bottom.estimatedSectionHeaderHeight = 0;
    self.tab_Bottom.estimatedSectionFooterHeight = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.page=1;
    _cityID = [KUserDefults objectForKey:kUserCityID];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self setUI];
    [self.tab_Bottom.mj_header beginRefreshing];
//    if ([[[YSAccountTool userInfo] modelId] isEqualToString:APPID]) {
//        self.btn_PYYY.hidden = YES;
//        self.btnView1.hidden = YES;
//    }
}
-(void)initData{
    self.data_Arr = [NSMutableArray array];
    WeakSelf
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page=1;
        [self requstLoad:@{@"cityID":_cityID?_cityID:@""}];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstLoad:@{@"cityID":_cityID?_cityID:@""}];
    }];
}
-(void)requstLoad:(NSDictionary *) dic{
    NSString * code = [KUserDefults objectForKey:YCode]?[KUserDefults objectForKey:YCode]:@"";
    NSDictionary * dic1 = @{
                           @"age": dic[@"age"]?dic[@"age"]:@"",
                           @"cityCode": @([code integerValue]),
                           @"distance": dic[@"distance"]?dic[@"distance"]:@"",
                           @"gender": dic[@"gender"]?dic[@"gender"]:@"",
//                           @"lat": @([dic[@"lat"]?dic[@"lat"]:[KUserDefults objectForKey:kLat] floatValue]),
//                           @"lng": @([dic[@"lng"]?dic[@"lng"]:[KUserDefults objectForKey:KLng] floatValue]),
                           @"pageNumber": @(self.page),
                           @"pageSize": @15,
                           @"userStatus": dic[@"userStatus"]?dic[@"userStatus"]:@"",
                           @"validType": dic[@"validType"]?dic[@"validType"]:@""
                           };
    WeakSelf
    [ServiceHomeNet requstTrvalDic:dic1 withSuc:^(NSMutableArray *successArrValue){
        if (weakSelf.page==1) {
            [self.data_Arr removeAllObjects];
        }
        weakSelf.page++;
        [self.data_Arr addObjectsFromArray:successArrValue];
        [self.tab_Bottom reloadData];
        [self.tab_Bottom.mj_header endRefreshing];
        [self.tab_Bottom.mj_footer endRefreshing];
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
    [self loadData:ID name:name lat:lat lng:lng];
    _cityID = ID;
//    _page=1;
//    [self requstLoad:@{@"cityID":ID,@"lat":lat,@"lng":lng}];
    self.btnView.width = [YSTools caculateTheWidthOfLableText:15 withTitle:name]+20;
}
-(void)cityMo:(CityMo *)mo{
    [self loadData:mo.ID name:mo.name lat:mo.lat lng:mo.lng];
    _cityID = mo.ID;
//    _page=1;
//    [self requstLoad:@{@"cityID":mo.ID,@"lat":mo.lat,@"lng":mo.lng}];
    self.btnView.width = [YSTools caculateTheWidthOfLableText:15 withTitle:mo.name]+20;
}
-(void)loadData:(NSString *)ID name:(NSString *)name lat:(NSString *)lat lng:(NSString *)lng{
    [self.backBtn setTitle:name forState:UIControlStateNormal];
    [self.data_Arr removeAllObjects];
    _cityID = ID;
    _page = 1;
    [self requstLoad:@{@"cityID":ID,@"lat":lat,@"lng":lng}];
    [self.tab_Bottom.mj_header beginRefreshing];
    self.trval.page=1;
    self.trval.cityID = ID;
    [self.trval.data_Arr removeAllObjects];
    [self.trval loadData:@{@"cityID":ID,@"lat":lat,@"lng":lng}];
    [self.trval.bollec_bottom.mj_header beginRefreshing];
    self.btnView.width = [YSTools caculateTheWidthOfLableText:15 withTitle:name]+20;
}
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}
//添加UI
-(void)setUI{
    [super setFlag_back:YES];//设置返回按钮
    self.btn_invit.layer.borderColor = YSColor(246, 207, 174).CGColor;
    self.btn_invit.layer.borderWidth = 2;
//    TrvalCell * cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][1];
//    self.tab_Bottom.tableHeaderView = cell;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"筛选" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.view addSubview:self.trval];
    [self initLeftBarButton];
}
-(void)initLeftBarButton{
    //为导航栏添加右侧按钮1
//    UIBarButtonItem  * left1 = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"return-f" title:nil EdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    UIBarButtonItem * left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-f"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    NSString * city = [KUserDefults objectForKey:kUserCity];
    CGFloat aa = [YSTools caculateTheWidthOfLableText:15 withTitle:city]+20;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(-40, 5,aa, 20)];
    view.backgroundColor = [UIColor clearColor];
    self.btnView = view;
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:city forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(CityClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, (aa-20)>80?80:(aa-20), 20);
    [view addSubview:btn];
    UIImageView * xiaImage = [[UIImageView alloc] init];
    xiaImage.image = [UIImage imageNamed:@"s-xiala"];
    xiaImage.frame = CGRectMake(btn.right+1, 8, 10, 8);
    [view addSubview:xiaImage];
    self.backBtn = btn;
//    [btn setImage:[UIImage imageNamed:@"s-xiala"] forState:UIControlStateNormal];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, -7, 0);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:view];
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
    cell.btn_detail.tag = cell.btn_send.tag = indexPath.row+1;
    cell.delegate = self;
    cell.receive_Mo = self.data_Arr[indexPath.row];
    return cell;
}
#pragma mark ------------
- (void)btnSend:(UIButton *)btn;{//私信
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    NSString *title,*ID,*name;
    trvalMo * mo = self.data_Arr[btn.tag-1];
    ID = [mo.user.ID description];
    name = mo.user.nickName;
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
-(void)DetailClick:(UIButton *)btn{//个人详情
    trvalMo * mo = self.data_Arr[btn.tag-1];
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.connectionMo = mo.user;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)setIsInvitOrTrval:(BOOL)isInvitOrTrval{
    _isInvitOrTrval = isInvitOrTrval;
    if (isInvitOrTrval) {//yes是旅行  NO 是陪游
        self.tab_Bottom.hidden = YES;
        self.trval.hidden = NO;
    }else{
        self.tab_Bottom.hidden = NO;
        self.trval.hidden = YES;
    }
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
        _trval = [[TrvalTrip alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-180) withControl:self];
        _trval.hidden = YES;
    }
    return _trval;
}

@end
