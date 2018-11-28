//
//  FollowController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FollowController.h"
#import "FollowHeadView.h"
#import "ListCell.h"
#import "NoticeView.h"
@interface FollowController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MyTab *tab_bottom;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (nonatomic,strong) NoticeView *noticeView;

@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tab_bottom registerClass:[FollowHeadView class] forHeaderFooterViewReuseIdentifier:@"FollowHeadView"];
    [self setUI];
}
-(void)setUI{
    [self.view_Bottom addSubview:self.noticeView];
}
#pragma mark ---------UITableviewDelegate----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil][0];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FollowHeadView * head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FollowHeadView"];
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (kScreenWidth-20)/5+35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(NoticeView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, 0, self.view_Bottom.width, 50) controller:self];
    }
    return _noticeView;
}
@end
