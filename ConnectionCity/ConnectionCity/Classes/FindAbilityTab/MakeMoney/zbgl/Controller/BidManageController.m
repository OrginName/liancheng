//
//  BidManageController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BidManageController.h"
#import "BidManagerCell.h"
#import "BidManagerFootV.h"
#import "BidManagerHeadV.h"
#import "ConsultativeNegotiationController.h"

@interface BidManageController ()<BidManagerCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BidManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BidManagerHeadV *tableHeadV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerHeadV" owner:nil options:nil] firstObject];
    tableHeadV.frame = CGRectMake(0, 0, kScreenWidth, 170);
    self.tableView.tableHeaderView = tableHeadV;
    BidManagerFootV *tableFootV = [[[NSBundle mainBundle] loadNibNamed:@"BidManagerFootV" owner:nil options:nil] firstObject];
    tableFootV.frame = CGRectMake(0, 0, kScreenWidth, 90);
    self.tableView.tableFooterView = tableFootV;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"招标管理";
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"BidManagerCell" bundle:nil] forCellReuseIdentifier:@"BidManagerCell"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BidManagerCell"];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BidManagerCellDelegate
- (void)bidManagerCell:(BidManagerCell *)view changeBtnClick:(UIButton *)btn {
    
}
- (void)bidManagerCell:(BidManagerCell *)view deleteBtnClick:(UIButton *)btn {
    
}
- (void)bidManagerCell:(BidManagerCell *)view negotiationBtnClick:(UIButton *)btn {
    ConsultativeNegotiationController *xsyjVC = [[ConsultativeNegotiationController alloc]init];
    [self.navigationController pushViewController:xsyjVC animated:YES];
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
