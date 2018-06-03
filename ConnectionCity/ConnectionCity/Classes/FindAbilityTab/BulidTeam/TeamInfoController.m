//
//  TeamInfoController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TeamInfoController.h"
#import "TeamHeadView.h"
#import "TeamHeadCell.h"
#import "TeamNameCell.h"
#import "TeamSwitchCell.h"
#import "TeamHeadView.h"

@interface TeamInfoController ()
@property (nonatomic,strong)TeamHeadView *teamHeadV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TeamInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self setUI];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamHeadCell" bundle:nil] forCellReuseIdentifier:@"TeamHeadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamNameCell" bundle:nil] forCellReuseIdentifier:@"TeamNameCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamSwitchCell" bundle:nil] forCellReuseIdentifier:@"TeamSwitchCell"];
    self.teamHeadV = [[[NSBundle mainBundle] loadNibNamed:@"TeamHeadView" owner:nil options:nil] firstObject];
    self.teamHeadV.frame = CGRectMake(0, 0, kScreenWidth, 300);
    self.tableView.tableHeaderView = self.teamHeadV;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, kScreenWidth - 10*2, 60 - 10*2);
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:YSColor(236,95,90)];
    [btn setTitle:@"删除并退出" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAndExitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
}
- (void)setUI {
    self.navigationItem.title = @"需求团队群";
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 3;
            break;
        }
        case 1:
        {
            return 4;
            break;
        }
        case 2:
        {
            return 2;
            break;
        }
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamHeadCell *headcell = [tableView dequeueReusableCellWithIdentifier:@"TeamHeadCell"];
    TeamNameCell *namecell = [tableView dequeueReusableCellWithIdentifier:@"TeamNameCell"];
    TeamSwitchCell *switchcell = [tableView dequeueReusableCellWithIdentifier:@"TeamSwitchCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return headcell;
        }else{
            return namecell;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return namecell;
        }else{
            return switchcell;
        }
    }else{
        if (indexPath.row == 0) {
            return namecell;
        }else{
            return switchcell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
#pragma mark - 点击事件
- (void)deleteAndExitBtnClick:(UIButton *)btn {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
