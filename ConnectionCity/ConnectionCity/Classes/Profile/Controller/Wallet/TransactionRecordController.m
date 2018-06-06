//
//  TransactionRecordController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TransactionRecordController.h"
#import "CustomButton.h"
#import "PresentCell.h"
@interface TransactionRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    CustomButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (weak, nonatomic) IBOutlet CustomButton *btn_All;
@end

@implementation TransactionRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"交易记录";
    self.btn_All.selected = YES;
    _tmpBtn = self.btn_All;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PresentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PresentCell2"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PresentCell" owner:nil options:nil][2];
    }
    return cell;
}
- (IBAction)BtnSelectClick:(CustomButton *)sender {
    if (sender.tag!=1) {
        self.btn_All.selected = NO;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}

@end
