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
#import "CircleNet.h"
#import "privateUserInfoModel.h"
#import "AllDicMo.h"
#import <IQKeyboardManager.h>
#import "RCDChatViewController.h"
@interface FriendCirleTab()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>
{
    NSInteger _page;
    NSInteger _CurrentTag;
}
@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) NSMutableArray *momentList;
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendCirleTab
-(instancetype)initWithFrame:(CGRect)frame withControll:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.controller = control;
        [self setUI];
        NSArray * arr = @[];
        if ([self.flagStr isEqualToString:@"HomeSend"]){
           arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"PICHOME"]];
        }else
           arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"PICTXT"]];
        [self defultData:arr];
        [self initTestInfo]; 
        _page=1;
        _CurrentTag= 0;
    }
    return self;
}
-(void)setUI{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
    self.tableHeaderView = self.headImage;
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
    self.mainView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [KWindowView addSubview:self.mainView];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.mainView.width-65, self.mainView.height-10)];
    textField.tag=10;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = @"请输入评论内容";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.mainView addSubview:textField];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 0, 40, self.mainView.height)];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:btn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark----发送-------
-(void)btnClicked{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    UITextField * txt  = (UITextField*)[self.mainView viewWithTag:10];
    if (txt.text.length==0) {
        [YTAlertUtil showTempInfo:@"请输入评论内容"];
        return;
    }
    AllContentMo * mo;
    if ([self.flagStr isEqualToString:@"HomeSend"]){
        mo = [arr[5] contentArr][5];
    }else{
       mo = [arr[5] contentArr][4];
    }
    NSDictionary * dic = @{
                           @"content": txt.text,
                           @"score": @0,
                           @"type": @([mo.value integerValue]),
                           @"typeId": @([[self.momentList[_CurrentTag] ID] integerValue])
                           };
    WeakSelf
    [CircleNet requstSendPL:dic withSuc:^(NSDictionary *successDicValue) {
        [txt resignFirstResponder];
        Moment * momet = weakSelf.momentList[_CurrentTag];
        momet.commentCount = [NSString stringWithFormat:@"%ld",[momet.commentCount integerValue]+1];
        Comment * comment = [Comment new];
        comment.content = txt.text;
        comment.typeName = [[YSAccountTool userInfo] nickName];
        [momet.comments addObject:comment];
        [weakSelf.momentList replaceObjectAtIndex:_CurrentTag withObject:momet];
        [weakSelf reloadData];
    }];
}
-(void)defultData:(NSArray *)arr{
    if (arr.count!=0) {
        [self.momentList addObjectsFromArray:arr];
        [self reloadData];
    }
}
#pragma mark - 测试数据
- (void)initTestInfo
{
    WeakSelf
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [weakSelf loadDataFriendList];
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataFriendList];
    }];
    [self.mj_header beginRefreshing];
//    NSMutableArray *commentList;
//    for (int i = 0;  i < 10; i ++)  {
//         // 评论
//        commentList = [[NSMutableArray alloc] init];
//        int num = arc4random()%5 + 1;
//        for (int j = 0; j < num; j ++) {
//            Comment *comment = [[Comment alloc] init];
//            comment.userName = @"胡一菲";
//            comment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来.";
//            comment.time = 6487649503;
//            comment.pk = j;
//            [commentList addObject:comment];
//        }
//
//        Moment *moment = [[Moment alloc] init];
//        moment.commentList = commentList;
//        moment.praiseNameList = @"";
//        moment.userName = @"Jeanne";
//        moment.location = @"江苏 苏州";
//        moment.time = 1487649403;
//        moment.singleWidth = 500;
//        moment.singleHeight = 315;
//        if (i == 0) {
//            moment.commentList = nil;
//            moment.praiseNameList = nil;
//            moment.location = @"";
//            moment.text = @"蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。";
//            moment.fileCount = 1;
//        } else if (i == 1) {
//            moment.text = @"天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来 😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍 ";
//            moment.fileCount = arc4random()%10;
//            moment.praiseNameList = nil;
//        } else if (i == 2) {
//            moment.fileCount = 9;
//        } else {
//            moment.text = @"天界大乱，九州屠戮，当初被推下地狱cheerylau@126.com的她已经浴火归来，😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍";
//            moment.fileCount = arc4random()%10;
//        }
//        [self.momentList addObject:moment];
//    }
}
//加载朋友圈列表
-(void)loadDataFriendList{
    NSDictionary * dic = @{};
    if ([self.flagStr isEqualToString:@"HomeSend"]) {
        dic = @{
                @"pageNumber": @(_page),
                @"pageSize": @15
                };
    }else{
        dic = @{
                @"containsImage": @1,
                @"containsVideo": @0,
                @"pageNumber": @(_page),
                @"pageSize": @15
                };
    }
    WeakSelf
    [CircleNet requstCirclelDic:dic flag:self.flagStr withSuc:^(NSMutableArray *successArrValue) {
        if (_page==1) {
            [weakSelf.momentList removeAllObjects];
        }
        _page++;
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        [weakSelf.momentList addObjectsFromArray:successArrValue];
        if ([self.flagStr isEqualToString:@"HomeSend"]) {
            [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:weakSelf.momentList] forKey:@"PICHOME"];
        }else
        [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:weakSelf.momentList] forKey:@"PICTXT"];
        [weakSelf reloadData];
    } FailErrBlock:^(NSError *failValue) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
    }];
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
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    MomentCell * cell1 = (MomentCell *)cell;
//    
//}
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
    mom.flagStr = self.flagStr;
    mom.receiveMo = self.momentList[indexPath.row];
    WeakSelf
    mom.block = ^{
        [weakSelf.momentList removeObjectAtIndex:indexPath.row];
        [weakSelf reloadData];
    };
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
    NSLog(@"击用户头像%ld",(long)cell.tag);
}
// 赞
-(void)didPraiseMoment:(MomentCell *)cell{
    NSLog(@"点赞%ld",(long)cell.tag);
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo;
    if ([self.flagStr isEqualToString:@"HomeSend"]) {
        mo = [arr[5] contentArr][5];
    }else{
       mo = [arr[5] contentArr][4];
    }
    WeakSelf
    [CircleNet requstCircleDZ:@{@"typeId":[self.momentList[cell.tag] ID],@"type":mo.value} withSuc:^(NSDictionary *successDicValue) {
//        cell.praiseBtn.selected = YES;
        Moment * momet = weakSelf.momentList[cell.tag];
        momet.likeCount = [NSString stringWithFormat:@"%ld",[momet.likeCount integerValue]+1];
        [weakSelf.momentList replaceObjectAtIndex:cell.tag withObject:momet];
        [weakSelf reloadData];
    }];
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
    UITextField * txt  = (UITextField*)[self.mainView viewWithTag:10];
    txt.text = @"";
    [txt becomeFirstResponder];
    _CurrentTag = cell.tag;
}
//分享
-(void)didShareMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
    [YSShareTool share];
}
//私信
-(void)didLetterMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    NSString *title,*ID,*name;
    Moment * mo = self.momentList[cell.tag];
    ID = [mo.userMo.ID description];
    name = mo.userMo.nickName;
    chatViewController.targetId = ID;
    if ([ID isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        title = [RCIM sharedRCIM].currentUserInfo.name;
    } else {
        title = name;
    }
    chatViewController.title = title;
    //        chatViewController.needPopToRootView = YES;
    chatViewController.displayUserNameInCell = NO;
    [self.controller.navigationController pushViewController:chatViewController animated:YES];
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
// 收缩键盘
-(void)dismissKeyBoard:(NSNotification *)notification
{
    [self kebordY:notification];
}
// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    [self kebordY:notification];
}
-(void)kebordY:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    WeakSelf
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        weakSelf.mainView.center = CGPointMake(weakSelf.mainView.center.x, keyBoardEndY);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
    }];
}
@end
