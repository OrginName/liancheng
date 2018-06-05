//
//  OurPlayController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurPlayController.h"
#import "CustomButton.h"
#import "OurPlayCell.h"
@interface OurPlayController ()<UITableViewDelegate,UITableViewDataSource>
{
     UIButton *_tmpBtn;
    NSInteger currentTag;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (weak, nonatomic) IBOutlet CustomButton *btn_All;
@end

@implementation OurPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"我的玩家";
    self.btn_All.selected = YES;
    _tmpBtn = self.btn_All;
    currentTag = 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OurPlayCell * cell = [OurPlayCell tempTableViewCellWith:tableView indexPath:indexPath currentTag:currentTag];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currentTag==1) {
        return 255;
    }else
        return 196;
}
- (IBAction)btnClick:(CustomButton *)sender {
    [self.tab_Bottom reloadData];
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
        
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    currentTag = sender.tag;
}

@end
