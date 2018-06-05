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
    self.navigationItem.title = [NSString stringWithFormat:@"我的发布-%@",self.receive_Mo.mTitle];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index==2) {
        return 97;
    }else if(self.index==7){
        return 66;
    }else
        return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell * cell = [ProfileCell tempTableViewCellWith:tableView indexPath:indexPath currentTag:self.index];
    cell.delegate = self;
    return cell;
}
#pragma mark -----profileCellDelegate-----
- (void)selectedItemButton:(NSInteger)index{
    NSLog(@"%ld",index);
}
@end
