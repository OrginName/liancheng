//
//  ClassificationsController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ClassificationsController.h"
#define leftCellIdentifier  @"leftCellIdentifier"
#define rightCellIdentifier @"rightCellIdentifier"

@interface ClassificationsController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Left;
@property (weak, nonatomic) IBOutlet UITableView *tab_Right;
@property (nonatomic,copy) NSArray * arr_left;
@property (nonatomic,copy) NSArray * arr_right;
@end

@implementation ClassificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initArr];
    [self registCell];
}
-(void)initArr{
    self.arr_left = @[@"经营管理",@"计算机/互联网",@"电子/电器/通信/电气",@"机器/机械仪表",@"产品",@"生产"];
    self.arr_right = @[@"经营管理",@"计算机/互联网",@"电子/电器/通信/电气",@"机器/机械仪表",@"产品",@"生产"];
}
-(void)registCell{
    self.tab_Left.tableFooterView = [[UIView alloc] init];
    self.tab_Right.tableFooterView = [[UIView alloc] init];
    [self.tab_Left registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
    [self.tab_Right registerClass:[UITableViewCell class] forCellReuseIdentifier:rightCellIdentifier];
}
#pragma mark - tableView 数据源代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tab_Left) return self.arr_left.count;
    return self.arr_right.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if (tableView == self.tab_Left) return 1;
//    return self.arr_left.count;
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    // 左边的 view
    if (tableView == self.tab_Left) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.arr_left[indexPath.row];
        // 右边的 view
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.arr_right[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor hexColorWithString:@"#656565"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (tableView == self.tab_Right) return [NSString stringWithFormat:@"第 %ld 组", section];
//    return nil;
//}
////MARK: - 一个方法就能搞定 右边滑动时跟左边的联动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 如果是 左侧的 tableView 直接return
//    if (scrollView == self.tab_Left) return;
//    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
//    NSIndexPath *topHeaderViewIndexpath = [[self.tab_Right indexPathsForVisibleRows] firstObject];
//    // 左侧 talbelView 移动的 indexPath
//    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
//    // 移动 左侧 tableView 到 指定 indexPath 居中显示
//    [self.tab_Left selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//}

//MARK: - 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选中 左侧 的 tableView
    if (tableView == self.tab_Left) {
//        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
//        // 将右侧 tableView 移动到指定位置
//        [self.tab_Right selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//        // 取消选中效果
//        [self.tab_Right deselectRowAtIndexPath:moveToIndexPath animated:YES];
        self.arr_right = @[@"上海市长宁区",@"北翟路靠近",@"上海市",@"北翟路靠近",@"长宁区"];
        [self.tab_Right reloadData];
    }else{
        self.block(self.arr_right[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidLayoutSubviews
{
    if ([self.tab_Left respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tab_Left setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tab_Left respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tab_Left setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tab_Right respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tab_Right setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tab_Right respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tab_Right setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
