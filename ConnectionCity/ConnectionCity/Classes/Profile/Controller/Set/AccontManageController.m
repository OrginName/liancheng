//
//  AccontManageController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AccontManageController.h"
#import "AccountManageCell.h"
#import "YSLoginController.h"

@interface AccontManageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,assign)NSInteger  selectRow;
@end

@implementation AccontManageController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title  = @"账号管理";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else
        return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManageCell * cell = [AccountManageCell tempTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section==0&&indexPath.row<3) {
        //重用机制，如果选中的行正好要重用
        if( indexPath.row ==_selectRow)
        {
            cell.iamge_Select.image = [UIImage imageNamed:@"our-chose"];
        } else {
            cell.iamge_Select.image = [UIImage imageNamed:@""];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.0001f;
    }else
        return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        view.backgroundColor = YSColor(239, 239, 239);
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        lab.text = @"在线状态";
        lab.textColor = YSColor(69, 69, 69);
        lab.font = [UIFont systemFontOfSize:14];
        [view addSubview:lab];
        return view;
    }else
        return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row<3) {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if(indexPath.row !=  _selectRow) { //selectedButton : 我这里是cell中得一个按钮属性
            AccountManageCell *newCell = (AccountManageCell *)[tableView cellForRowAtIndexPath:indexPath];
            newCell.iamge_Select.image = [UIImage imageNamed:@"our-chose"]; //yes:打勾状态
            AccountManageCell *oldCell = (AccountManageCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectRow inSection:0]];
            oldCell.iamge_Select.image = [UIImage imageNamed:@""];
            _selectRow= indexPath.row;
        }
    }else if (indexPath.section==1&&indexPath.row==0){
        AccountManageCell *newCell = (AccountManageCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.image_onLine.selected = !newCell.image_onLine.selected;
    }else if (indexPath.section==1&&indexPath.row==1){
//        [YTAlertUtil showTempInfo:@"退出登录"];
        [YSAccountTool deleteAccount];
        YSLoginController *loginVC = [[YSLoginController alloc]init];
        BaseNavigationController * base = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [kWindow setRootViewController:base];
    }
}
@end
