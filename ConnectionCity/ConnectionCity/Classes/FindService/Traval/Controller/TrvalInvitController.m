//
//  TrvalInvitController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalInvitController.h"
#import "TrvalCell.h"
@interface TrvalInvitController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * Arr_Dic;
@end

@implementation TrvalInvitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    self.Arr_Dic = [NSMutableArray array];
}
-(void)initData{
    [YSNetworkTool POST:dictionaryDictionaryAll params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.Arr_Dic = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)SearchClick{
    [YTAlertUtil showTempInfo:@"旅行邀约发布"];
}
-(void)setUI{
    self.navigationItem.title = @"旅行邀约";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(SearchClick) image:@"" title:@"发布" EdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 4;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrvalCell * cell = [TrvalCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.txt_View.placeholder = @"简单说说您对报名人的要求、旅行计划的安排说明";
    cell.txt_View.placeholderColor = YSColor(166, 166, 166);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section==0&&indexPath.row==1)||indexPath.section==1) {
        NSArray * arr = self.Arr_Dic[17+indexPath.row][@"content"];
         
    }
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TrvalCell * cell = [[NSBundle mainBundle] loadNibNamed:@"TrvalCell" owner:nil options:nil][1];
    cell.lab_headTitle.text = section==0?@"我要去哪里":section==1?@"计划安排":section==2?@"计划说明":@"";
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section!=2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
        view.backgroundColor = YSColor(239, 239, 239);
        return view;
    }else
        return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=2) {
        return 10;
    }else
        return 0.0001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 96;
    }else
        return 50;
}
@end
