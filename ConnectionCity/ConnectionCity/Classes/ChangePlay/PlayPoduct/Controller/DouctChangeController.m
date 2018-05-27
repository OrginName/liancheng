//
//  DouctChangeController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "DouctChangeController.h"
#import "PlayDouctCell.h"
@interface DouctChangeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong) NSMutableArray * arr_Select;
@end

@implementation DouctChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
}
-(void)initData{
    self.arr_Select = [NSMutableArray array];
}
-(void)setUI{
    self.navigationItem.title = @"交换";
}
#pragma mark --- 各种按钮点击方法------
- (IBAction)btn_ChangeClick:(UIButton *)sender {
   __block NSString * str = @"";
    [self.arr_Select enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        str = [NSString stringWithFormat:@"%@-%@",str,obj];
    }];
    [YTAlertUtil showTempInfo:str];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlayDouctCell3"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PlayDouctCell" owner:nil options:nil][3];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.btn_SelectChange.selected = !cell.btn_SelectChange.selected;
    if (![self.arr_Select containsObject:@(indexPath.row)]) {
        [self.arr_Select addObject:@(indexPath.row)];
    }else
        [self.arr_Select removeObject:@(indexPath.row)];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayDouctCell * cell1 = (PlayDouctCell *)cell;
    if ([self.arr_Select containsObject:@(indexPath.row)]) {
        cell1.btn_SelectChange.selected = YES;
    }else
        cell1.btn_SelectChange.selected = NO;
}
@end
