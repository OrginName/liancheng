//
//  ResumeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ResumeController.h"
#define leftCellIdentifier @"leftCellIdentifier"
@interface ResumeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;

@end

@implementation ResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"个人简历";
    [self setUI];
 
}
//导航栏完成按钮点击
-(void)complete{
    
}
//添加UI
-(void)setUI{
   [self.tab_bottom registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
}
#pragma mark - tableView 数据源代理方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)initRightItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
@end
