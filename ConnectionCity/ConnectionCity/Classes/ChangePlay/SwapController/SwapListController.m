//
//  SwapListController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SwapListController.h"
#import "SwapHomeCell.h"
#import "ShowResumeController.h"
#import "UIView+Geometry.h"
#import "JFCityViewController.h"
#import "ChangePlayNet.h"
@interface SwapListController ()<UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) UIView * btnView;
@property (nonatomic,strong) UIButton * backBtn;
@end
@implementation SwapListController
- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];//设置返回按钮
    [self setUI];
    [self loadData];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
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
//加载互换身份数据
-(void)loadData{
    NSDictionary * dic = @{
                           @"cityCode": @100010,
                           @"pageNumber": @1,
                           @"pageSize": @15
                           };
    [ChangePlayNet requstHHList:dic sucBlock:^(NSMutableArray *successArrValue) {
        
    } failBlock:^(NSError *failValue) {
        
    }];
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
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeCard;
    [self.navigationController pushViewController:show animated:YES];
}

@end
