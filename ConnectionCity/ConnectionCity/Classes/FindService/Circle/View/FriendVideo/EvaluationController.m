//
//  EvaluationController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EvaluationController.h"
#import "CircleCell.h"
#import "CircleNet.h"
#import "Moment.h"
@interface EvaluationController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong)NSMutableArray * array;
@end

@implementation EvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self setUI];
    if (self.service==nil) {
        [self initData];
    }
}
-(void)setService:(myServiceMo *)service{
    _service = service;
    if (service!=nil) {
        self.array = [service.obj.commentList mutableCopy];
        [self.tab_bottom reloadData];
    }
}
-(void)setUI{
    self.array = [NSMutableArray array];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
}
-(void)initData{
    [CircleNet requstCircleDetail:@{@"id":self.moment.ID} withSuc:^(NSMutableArray *successArrValue) {
        self.array = successArrValue;
        [self.tab_bottom reloadData];
    }];
}
-(void)ClearAll{
//    [YTAlertUtil showTempInfo:@"清空"];
    [YSNetworkTool POST:v1ServiceCircleDelete params:@{@"id":self.moment.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.block();
        [YTAlertUtil showTempInfo:@"删除成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:nil options:nil][0];
    }
    if (self.service!=nil) {
        cell.mo = self.array[indexPath.row];
    }
    cell.moment = self.array[indexPath.row];
    return cell;
}
@end
