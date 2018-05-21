//
//  FootprintController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FootprintController.h"
#import "FootSectionHeadV.h"
#import "FootprintCell.h"
#import "MarginCell.h"

@interface FootprintController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
//    self.view.backgroundColor = [UIColor redColor];
//    self.tableView.backgroundColor = [UIColor orangeColor];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup

- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"MarginCell" bundle:nil] forCellReuseIdentifier:@"MarginCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FootprintCell" bundle:nil] forCellReuseIdentifier:@"FootprintCell"];
    [self.tableView registerClass:[FootSectionHeadV class] forHeaderFooterViewReuseIdentifier:@"FootSectionHeadV"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarginCell *biddercell = [tableView dequeueReusableCellWithIdentifier:@"MarginCell"];
    FootprintCell *winnercell = [tableView dequeueReusableCellWithIdentifier:@"FootprintCell"];
    if (indexPath.section % 2) {
        return biddercell;
    }else{
        return winnercell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 101;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    FootSectionHeadV *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FootSectionHeadV"];
    if (section % 2) {
        headerView.headerImgV.image = [UIImage imageNamed:@"Bid"];
        headerView.bidderLab.text = @"投标";
    }else{
        headerView.headerImgV.image = [UIImage imageNamed:@"Win"];
        headerView.bidderLab.text = @"中标";
    }
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
