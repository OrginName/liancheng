//
//  SwapController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//
#import "SwapController.h"
#import "SwapHeadView.h"
#import "SwapHomeCell.h"
#import "SendSwapController.h"
#import "ShowResumeController.h"
#import "ChangePlayNet.h"
#import "UIView+Geometry.h"
#import "JFCityViewController.h"
@interface SwapController ()<UITableViewDelegate,UITableViewDataSource,SwapHeadDelegate,JFCityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) SwapHeadView * headView;
@property (nonatomic,strong) UIView * btnView;
@property (nonatomic,strong) UIButton * backBtn;
@end
@implementation SwapController
- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];//设置返回按钮
    [self setUI];
    [self loadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initHeadView];
}
-(void)setUI{
   self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    //为导航栏添加右侧按钮1
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
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:view];
    NSArray *  arr = @[left1,right2];
    self.navigationItem.leftBarButtonItems = arr;
    [self initNavi];
    [self initNavi];
} 
//互换身份按钮点击
-(void)AddressClick:(UIButton *)btn{
    [YTAlertUtil showTempInfo:@"互换身份"];
}
//发布按钮点击
-(void)SearchClick{
    [self.navigationController pushViewController:[super rotateClass:@"SendSwapController"] animated:YES];
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
    //    [self loadData:ID name:name];
    //    _cityID = ID;
    [self.tab_Bottom.mj_header beginRefreshing];
    self.btnView.width = [YSTools caculateTheWidthOfLableText:15 withTitle:name]+20;
}
-(void)cityMo:(CityMo *)mo{
    //    [self loadData:mo.ID name:mo.name];
    //    _cityID = mo.ID;
    [self.tab_Bottom.mj_header beginRefreshing];
    self.btnView.width = [YSTools caculateTheWidthOfLableText:15 withTitle:mo.name]+20;
}
//加载
-(void)loadData{
    NSDictionary * dic = @{
                           @"cityCode": @320200,
                           @"pageNumber": @1,
                           @"pageSize": @5
                           };
    [ChangePlayNet requstHHList:dic sucBlock:^(NSMutableArray *successArrValue) {
        
    } failBlock:^(NSError *failValue) {
        
    }];
}
//表头部点击
#pragma mark ----SwapHeadDelegate-----
-(void)swapHeadClick:(NSInteger )tag
{
    NSArray * arr = @[@"SwapListController",@"SwapListController",@"SwapListController",@"SwapListController",@"SwapListController",@"SwapListController"];
    [self.navigationController pushViewController:[super rotateClass:arr[tag-1]] animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwapHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SwapHomeCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowResumeController * resume = [ShowResumeController new];
    resume.Receive_Type = ENUM_TypeCard;
    [self.navigationController pushViewController:resume animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view_headSection = [UIView new];
    view_headSection.frame = CGRectMake(0, 0, kScreenWidth-20, 40);
    view_headSection.backgroundColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 10, 10)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = YSColor(0, 185, 161);
    [view_headSection addSubview:view];
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, view_headSection.width-40, view_headSection.height)];
    titleLabel.text = @"最新";
    titleLabel.textColor = YSColor(34, 34, 34);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    [view_headSection addSubview:titleLabel];
    return view_headSection;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(void)initNavi{
    //自定义标题视图
    UIView * nav_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    btn.tag = 99999;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"互换身份" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Arrow-xia"] forState:UIControlStateNormal];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [btn addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [nav_view addSubview:btn];
    self.navigationItem.titleView = nav_view;
}
//添加UITableview表头
-(void)initHeadView{
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"SwapHeadView" owner:nil options:nil] lastObject];
    self.headView.delegate = self;
    self.tab_Bottom.tableHeaderView.frame = CGRectMake(0, 0, self.tab_Bottom.width, 361);
    self.tab_Bottom.tableHeaderView = self.headView;
}
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}
@end
