//
//  FirstController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstController.h"
#import "FirstTableViewCell.h"
#import "FirstSectionHeadV.h"
#import "ReleaseTenderController.h"

@interface FirstController ()<FirstSectionHeadVDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"FirstTableViewCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTableViewCell"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //重用区头视图
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (headerView.subviews.count == 1) {
        FirstSectionHeadV *sectinV = [[[NSBundle mainBundle] loadNibNamed:@"FirstSectionHeadV" owner:nil options:nil] firstObject];
        sectinV.delegate = self;
        sectinV.frame = CGRectMake(0, 0, kScreenWidth - 20, 100);
        [headerView addSubview:sectinV];
    }
    //返回区头视图
    return headerView;
}
#pragma mark - FirstSectionHeadVDelegate
- (void)firstSectionHeadV:(FirstSectionHeadV *)view fbzbBtnClick:(UIButton *)btn {
    ReleaseTenderController *fbVC = [[ReleaseTenderController alloc]init];
    [self.navigationController pushViewController:fbVC animated:YES];
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view zbglBtnClick:(UIButton *)btn {
    
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view cityBtnClick:(UIButton *)btn {
    
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view typeBtnClick:(UIButton *)btn {
    
}
- (void)firstSectionHeadV:(FirstSectionHeadV *)view timeBtnClick:(UIButton *)btn {
    
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
