//
//  TTController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TTController.h"
#import "TTCell.h"
#import "ReceMo.h"
#import "SendMomentController.h"
@interface TTController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;

@end
@implementation TTController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrReceive.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTMo * mo = self.arrReceive[indexPath.section];
    NSString * iden = [mo.type isEqualToString:@"10"]?@"TTCell":@"TTCell1";
    NSInteger index = [mo.type isEqualToString:@"10"]?0:1;
    TTCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TTCell" owner:nil options:nil][index];
    }
    cell.block = ^{
        SendMomentController * send = [SendMomentController new];
        send.flagStr = @"CircleSend";
        [self.navigationController pushViewController:send animated:YES];
    };
    cell.mo = mo;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
@end
