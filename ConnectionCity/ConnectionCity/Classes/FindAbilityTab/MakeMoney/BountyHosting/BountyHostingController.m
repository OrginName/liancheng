//
//  BountyHostingController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BountyHostingController.h"
#import "MarginCell.h"
#import "MarginSectionHeadV.h"

@interface BountyHostingController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BountyHostingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
-(void)setUI {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(p_back) image:@"return-f" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"MarginCell" bundle:nil] forCellReuseIdentifier:@"MarginCell"];
    [self.tableView registerClass:[MarginSectionHeadV class] forHeaderFooterViewReuseIdentifier:@"MarginSectionHeadV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarginCell"];
    cell.titleLab.text = [NSString stringWithFormat:@"赏金%ld期",(long)indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    MarginSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MarginSectionHeadV"];
    //返回区头视图
    return headerView;
}
#pragma mark - profile method
-(void)p_back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BACKMAINWINDOW" object:nil];
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
