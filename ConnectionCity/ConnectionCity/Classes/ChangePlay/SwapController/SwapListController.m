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
@interface SwapListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@end

@implementation SwapListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];//设置返回按钮
    [self setUI];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    //为导航栏添加右侧按钮1
    UIBarButtonItem * left1 = [UIBarButtonItem itemWithRectTarget:self action:@selector(back) image:@"return-f" title:@"" withRect:CGRectMake(0, 0, 10, 10)];
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"苏州市" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(SearchClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"s-xiala"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, -7, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
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
