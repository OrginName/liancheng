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
@interface TravalController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * _tmpBtn;
}
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
}
#pragma mark ---按钮点击事件-----
-(void)SearchClick{
    [YTAlertUtil showTempInfo:@"筛选"];
}
- (IBAction)send_invit:(UIButton *)sender {
    [self.navigationController pushViewController:[super rotateClass:@"TrvalInvitController"] animated:YES];
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
        self.view_tab.hidden = YES;
        self.trval.hidden = NO;
    }else{
        self.view_tab.hidden = NO;
        self.trval.hidden = YES;
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
        _trval = [[TrvalTrip alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth-20, kScreenHeight-195)];
        _trval.hidden = YES;
    }
    return _trval;
}

@end
