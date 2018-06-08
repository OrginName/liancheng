//
//  FriendCirleTab.m
//  ConnectionCity
//
//  Created by qt on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendCirleTab.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "MomentDetailController.h"
@interface FriendCirleTab()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) NSMutableArray *momentList;
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendCirleTab
-(instancetype)initWithFrame:(CGRect)frame withControll:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.controller = control;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = self.headImage;
        [self initTestInfo];
    }
    return self;
}
#pragma mark - 测试数据
- (void)initTestInfo
{
    NSMutableArray *commentList;
    for (int i = 0;  i < 10; i ++)  {
         // 评论
        commentList = [[NSMutableArray alloc] init];
        int num = arc4random()%5 + 1;
        for (int j = 0; j < num; j ++) {
            Comment *comment = [[Comment alloc] init];
            comment.userName = @"胡一菲";
            comment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来.";
            comment.time = 6487649503;
            comment.pk = j;
            [commentList addObject:comment];
        }
        
        Moment *moment = [[Moment alloc] init];
        moment.commentList = commentList;
        moment.praiseNameList = @"";
        moment.userName = @"Jeanne";
        moment.location = @"江苏 苏州";
        moment.time = 1487649403;
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        if (i == 0) {
            moment.commentList = nil;
            moment.praiseNameList = nil;
            moment.location = @"";
            moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
            moment.fileCount = 1;
        } else if (i == 1) {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来 😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍 ";
            moment.fileCount = arc4random()%10;
            moment.praiseNameList = nil;
        } else if (i == 2) {
            moment.fileCount = 9;
        } else {
            moment.text = @"天界大乱，九州屠戮，当初被推下地狱cheerylau@126.com的她已经浴火归来，😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍";
            moment.fileCount = arc4random()%10;
        }
        [self.momentList addObject:moment];
    }
}
- (NSMutableArray *)momentList
{
    if (!_momentList) {
        _momentList = [[NSMutableArray alloc] init];
    }
    return _momentList;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.momentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.tag = indexPath.row;
    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentDetailController * mom = [MomentDetailController new];
    mom.receiveMo = self.momentList[indexPath.row];
    [self.controller.navigationController pushViewController:mom animated:YES];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [MomentCell momentCellHeightForMoment:[self.momentList objectAtIndex:indexPath.row]];
    return height;
}
#pragma mark - MomentCellDelegate
// 点击用户头像
- (void)didClickHead:(MomentCell *)cell
{
    NSLog(@"击用户头像");
}
// 赞
- (void)didLikeMoment:(MomentCell *)cell
{
    NSLog(@"点赞");
}
// 评论
- (void)didAddComment:(MomentCell *)cell
{
    NSLog(@"评论");
}
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    [self reloadData];
}
// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText momentCell:(MomentCell *)cell
{
    NSLog(@"点击高亮文字：%@",linkText);
}

//评论
-(void)didCommentMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
}
//分享
-(void)didShareMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
}
//私信
-(void)didLetterMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    //    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
} 
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 250)];
        _headImage.image = [UIImage imageNamed:@"1"];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(_headImage.width-70, _headImage.height-25, 50, 50)];
        image1.image = [UIImage imageNamed:@"1"];
        image1.layer.cornerRadius = 25;
        image1.layer.masksToBounds = YES;
        [_headImage addSubview:image1];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(image1.x-40, image1.y, 100, 25)];
        lab.text = @"菲菲二";
        lab.textColor = YSColor(55, 21, 17);
        lab.font = [UIFont systemFontOfSize:14];
        [_headImage addSubview:lab];
    }
    return _headImage;
}
@end
