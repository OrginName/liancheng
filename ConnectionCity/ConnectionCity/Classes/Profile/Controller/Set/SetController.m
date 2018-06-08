//
//  SetController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SetController.h"
#import "PresentCell.h"
#import "AddMyWayController.h"
@interface SetController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * arr_controller;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,copy) NSArray * arr_Title;
@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
}
-(void)setUI{
    self.navigationItem.title = @"设置";
    arr_controller = @[@"AccontManageController",@"AccountOneController",@"AccontManageController",@"AddMyWayController",@"PrivateController",@"AboutOurController",@"AccontManageController"];
}
-(void)initData{
    self.arr_Title = @[@"账号管理",@"账号安全",@"消息通知",@"聊天记录",@"隐私联系人",@"关于连程",@"退出"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_Title.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PresentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PresentCell3"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PresentCell" owner:nil options:nil][3];
    }
    cell.lab_Settitle.text = self.arr_Title[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2||indexPath.row==3) {
        AddMyWayController * add = [AddMyWayController new];
        if (indexPath.row==3) {
            add.index_receive = 3;
            add.title = @"聊天记录";
        }else{
            add.index_receive = 4;
            add.title = @"消息通知";
        }
        [self.navigationController pushViewController:add animated:YES];
    }else
    [self.navigationController pushViewController:[super rotateClass:arr_controller[indexPath.row]] animated:YES];
}
@end
