//
//  SendServiceController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendServiceController.h"
#import "PhotoSelect.h"
#import "SendServiceCell.h"
@interface SendServiceController ()<PhotoSelectDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat itemHeigth,layout_Height;
    UIButton * _tmpBtn;
}

@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;
@property (nonatomic,strong)PhotoSelect * photo;

@end

@implementation SendServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布服务";
    [self setUI];
}
-(void)setUI{
    itemHeigth = (self.tab_Bottom.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.tab_Bottom.tableHeaderView = self.photo;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark ---- 各种按钮点击i-----
-(void)complete{
    [YTAlertUtil showTempInfo:@"完成"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section!=2) {
        return 1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==5) {
        return 10;
    }else
        return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendServiceCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 10)];
    view.backgroundColor = YSColor(239, 239, 239);
    return view;
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height = itemHeigth*2;
        [self.tab_Bottom.tableHeaderView layoutIfNeeded];
        UIView *headerView = self.tab_Bottom.tableHeaderView;
        headerView.height = self.photo.height;
        [self.tab_Bottom beginUpdates];
        [self.tab_Bottom setTableHeaderView:headerView];// 关键是这句话
        [self.tab_Bottom endUpdates];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    self.photo.height = layout_Height;
}
@end
