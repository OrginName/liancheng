//
//  OurResumeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "OurResumeController.h"
#import "ProfileCell.h"
@interface OurResumeController ()<UITableViewDelegate,UITableViewDataSource,profileCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;

@end

@implementation OurResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"我的发布-简历";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell1"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:nil options:nil][1];
    }
    cell.delegate = self;
    return cell;
}
#pragma mark -----profileCellDelegate-----
- (void)selectedItemButton:(NSInteger)index{
    
}
@end
