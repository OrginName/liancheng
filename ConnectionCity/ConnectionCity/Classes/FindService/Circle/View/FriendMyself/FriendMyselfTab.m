//
//  FriendMyselfTab.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendMyselfTab.h"
#import "FindMySelfCell.h"
#import "privateUserInfoModel.h"
#import "SendMomentController.h"
@interface FriendMyselfTab()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendMyselfTab
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withControll:(UIViewController *)control{
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = self.headImage;
        self.rowHeight = 86;
        self.controller = control;
    }
    return self;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindMySelfCell * cell = [FindMySelfCell tempTableViewCellWith:tableView indexPath:indexPath];
    [self bringSubviewToFront:[self.tableHeaderView viewWithTag:11111111]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 78;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FindMySelfCell * cell = [[NSBundle mainBundle] loadNibNamed:@"FindMySelfCell" owner:nil options:nil][0];
    UIButton * btn = [[UIButton alloc] initWithFrame:cell.frame];
    btn.tag = section;
    [btn addTarget:self action:@selector(SectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    if (section!=0) {
        cell.image_photo.hidden = YES;
        cell.lab_Time.text = @"2100";
        cell.lab_Time.font = [UIFont systemFontOfSize:20];
        cell.lab_Time.textColor = [UIColor blackColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ----SectionClick-----
-(void)SectionClick:(UIButton *)btn{
    if (btn.tag==0) {
        SendMomentController * send = [SendMomentController new];
        send.title = @"服务圈";
        [self.controller.navigationController pushViewController:send animated:YES];
    }
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 250)];
        privateUserInfoModel * userInfo = [YSAccountTool userInfo];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.backgroundImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(_headImage.width-70, _headImage.height-25, 50, 50)];
        [image1 sd_setImageWithURL:[NSURL URLWithString:userInfo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
        image1.layer.cornerRadius = 25;
        image1.layer.masksToBounds = YES;
        [_headImage addSubview:image1];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(image1.x-40, image1.y, 100, 25)];
        lab.text = userInfo.nickName;
        lab.textColor = YSColor(55, 21, 17);
        lab.font = [UIFont systemFontOfSize:14];
        [_headImage addSubview:lab];
    }
    return _headImage;
}
@end
