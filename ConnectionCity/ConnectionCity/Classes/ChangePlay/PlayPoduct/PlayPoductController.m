//
//  PlayPoductController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PlayPoductController.h"
#import "SendTreasureController.h"
#import "PlayDouctCell.h"
#import "PlayEditController.h"
@interface PlayPoductController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * Arr_Data;
@end

@implementation PlayPoductController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];//设置返回按钮
    [self setUI];
    [self initData];
}
-(void)initData{
    self.Arr_Data = [NSMutableArray array];
//    [self.Arr_Data addObjectsFromArray:@[@"1",@"2",@"4",@"r"]];
}
-(void)setUI{
    [self initNavibarItem];
}
#pragma mark ---各种按钮点击事件-------
-(void)Edit{
    if (self.Arr_Data.count==0) {
        [YTAlertUtil showTempInfo:@"暂无宝物,请点击发布宝物"];
    }else{
        [self.navigationController pushViewController:[super rotateClass:@"PlayEditController"] animated:YES];
    }
}
#pragma mark-----UITableViewDelegate------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Arr_Data.count==0) {
        return 100;
    }else
        return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.Arr_Data.count==0) {
        return 1;
    }else
        return self.Arr_Data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell  = [PlayDouctCell tempTableViewCellWith:tableView indexPath:indexPath withCollArr:self.Arr_Data];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.Arr_Data.count==0&&indexPath.row==0) {
        SendTreasureController * send = [SendTreasureController new];
        [self.navigationController pushViewController:send animated:YES];
    }else{
        [YTAlertUtil showTempInfo:@"查看详情"];
    }
}
-(void)initNavibarItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Edit) image:@"" title:@"编辑" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
@end
