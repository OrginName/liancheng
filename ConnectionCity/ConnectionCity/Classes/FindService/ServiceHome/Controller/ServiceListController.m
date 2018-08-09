//
//  ServiceListController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceListController.h"
#import "ServiceListCell.h"
#import "ServiceHomeNet.h"
#import "privateUserInfoModel.h"
#import "ShowResumeController.h"
@interface ServiceListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * arr_data;
@end

@implementation ServiceListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"服务约单";
    self.arr_data = [NSMutableArray array];
    [self loadServiceList];
}
//加载服务列表数据
-(void)loadServiceList{
    NSDictionary * dic1 = @{
                            @"cityCode":self.user.cityCode?self.user.cityCode:@"",
                            @"lat": @([self.user.lat floatValue]),
                            @"lng": @([self.user.lng floatValue]),
                            @"userId":self.user.ID
                            };
    //    加载服务列表
    [ServiceHomeNet requstServiceList:dic1 withSuc:^(NSMutableArray *successArrValue) {
        self.arr_data = successArrValue;
        [self.tab_Bottom reloadData];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceListCell" owner:nil options:nil] lastObject];
    }
    cell.list = self.arr_data[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTrval;
    show.data_Count = self.arr_data;
    show.zIndex = indexPath.row;
    [self.navigationController pushViewController:show animated:YES];
}
@end
