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
@interface TravalController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate>
{
    UIButton * _tmpBtn;
   
}
@property (weak, nonatomic) IBOutlet UIButton *btn_PYYY;
@property (nonatomic,strong)TrvalTrip * trval;
@property (weak, nonatomic) IBOutlet UIButton *btn_travl;
@property (weak, nonatomic) IBOutlet UIButton *btn_invit;
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (weak, nonatomic) IBOutlet UIView *view_tab;

@end
@implementation TravalController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
//    _page=1;
}
-(void)initData{
    [self requstLoad:@{}];
    [self.tab_Bottom.mj_header beginRefreshing];
}
-(void)requstLoad:(NSDictionary *) dic1{
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.btn_invit.selected) {
            [self.tab_Bottom.mj_header endRefreshing];
        }
    }];
    self.tab_Bottom.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.btn_invit.selected) {
            
        }
    }];
}
#pragma mark ---按钮点击事件-----
//筛选
-(void)SearchClick{
    FilterOneController * filter = [FilterOneController new];
    filter.title = @"筛选条件";
    filter.flag_SX = 1;
    [self.navigationController pushViewController:filter animated:YES];
}
- (IBAction)send_invit:(UIButton *)sender {
    NSString * str = @"";
    if ([sender.titleLabel.text isEqualToString:@"发布陪游"]) {
        str = @"SendTripController";
    } else {
        str = @"TrvalInvitController";
    }
    [self.navigationController pushViewController:[super rotateClass:str] animated:YES];
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
-(void)cityMo:(CityMo *)mo{
    
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
    [btn setTitle:@"苏州市" forState:UIControlStateNormal];
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
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TrvalCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][0];
    }
    return cell;
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
