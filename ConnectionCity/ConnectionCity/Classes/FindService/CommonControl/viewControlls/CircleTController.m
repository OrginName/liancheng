//
//  CircleTController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CircleTController.h"
#import "PersonNet.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "MomentDetailController.h"
#import "PersonalBasicDataController.h"
#import "privateUserInfoModel.h"
#import "AllDicMo.h"
#import <IQKeyboardManager.h>
#import "RCDChatViewController.h"
#import "CircleNet.h"
@interface CircleTController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate,CommentViewDelegate>
{
    NSInteger _CurrentTag;
    NSString * _cityCode;
}
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) NSMutableArray *momentList;
@end

@implementation CircleTController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    self.tab_Bottom.estimatedRowHeight = 0;
    self.tab_Bottom.estimatedSectionHeaderHeight = 0;
    self.tab_Bottom.estimatedSectionFooterHeight = 0;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.comment removeFromSuperview];
//    self.comment =nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    [self initTestInfo];
    [self setComment];
}
#pragma mark -----CommentViewDelegate------
- (void)sendValue{
    [self btnClicked];
}
-(void)defultData:(NSArray *)arr{
    if (arr.count!=0) {
        [self.momentList addObjectsFromArray:arr];
        [self.tab_Bottom reloadData];
    }
}
#pragma mark----发送-------
-(void)btnClicked{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    if (self.comment.textField.text.length==0) {
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
                           @"content": self.comment.textField.text,
                           @"score": @0,
                           @"type": @([mo.value integerValue]),
                           @"typeId": @([[self.momentList[_CurrentTag] ID] integerValue])
                           };
    WeakSelf
    [CircleNet requstSendPL:dic withSuc:^(NSDictionary *successDicValue) {
        [weakSelf.comment.textField resignFirstResponder];
        Moment * momet = weakSelf.momentList[_CurrentTag];
        momet.commentCount = [NSString stringWithFormat:@"%ld",[momet.commentCount integerValue]+1];
        Comment * comment = [Comment new];
        comment.content = weakSelf.comment.textField.text;
        comment.typeName = [[YSAccountTool userInfo] nickName];
        comment.user = [UserMo new];
        comment.user.ID = [[YSAccountTool userInfo] modelId];
        comment.user.headImage = [[YSAccountTool userInfo] headImage];
        [momet.comments addObject:comment];
        [weakSelf.momentList replaceObjectAtIndex:_CurrentTag withObject:momet];
        NSIndexPath * index = [NSIndexPath indexPathForRow:_CurrentTag inSection:0];
        [weakSelf.tab_Bottom reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark - 测试数据
- (void)initTestInfo
{
    WeakSelf
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [weakSelf loadDataFriendList];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataFriendList];
    }];
    [self loadDataFriendList];
    
}
//加载朋友圈列表
-(void)loadDataFriendList{
    NSDictionary * dic = @{
                           @"containsImage": @1,
                           @"containsVideo": @0,
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           @"userId": self.userID
                           };
    
    WeakSelf
    [PersonNet requstPersonVideo:dic withArr:^(NSMutableArray * _Nonnull successArrValue) {
        if (_page==1) {
            [weakSelf.momentList removeAllObjects];
        }
        _page++;
        [weakSelf.tab_Bottom.mj_header endRefreshing];
        [weakSelf.tab_Bottom.mj_footer endRefreshing];
        [weakSelf.momentList addObjectsFromArray:successArrValue]; 
        [weakSelf.tab_Bottom reloadData];
    } FailDicBlock:^(NSError * _Nonnull failValue) {
        [weakSelf.tab_Bottom.mj_header endRefreshing];
        [weakSelf.tab_Bottom.mj_footer endRefreshing];
    }];
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
    cell.delegate = self;
    cell.moment = [self.momentList objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentDetailController * mom = [MomentDetailController new];
    mom.flagStr = self.flagStr;
    mom.receiveMo = self.momentList[indexPath.row];
    WeakSelf
    mom.block = ^{
        [weakSelf.momentList removeObjectAtIndex:indexPath.row];
        [weakSelf.tab_Bottom reloadData];
    };
    [self.navigationController pushViewController:mom animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    Moment * moment = self.momentList[cell.tag];
    person.connectionMo = moment.userMo;
    [self.navigationController pushViewController:person animated:YES];
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
    [CircleNet requstCircleDZ:@{@"typeId":[self.momentList[cell.tag] ID],@"type":mo.value,@"commentedUserId":[[YSAccountTool userInfo] modelId]} withSuc:^(NSDictionary *successDicValue) {
        //        cell.praiseBtn.selected = YES;
        Moment * momet = weakSelf.momentList[cell.tag];
        momet.likeCount = KString(@"%@", successDicValue[@"data"]);
        [weakSelf.momentList replaceObjectAtIndex:cell.tag withObject:momet];
        [weakSelf.tab_Bottom reloadData];
    }];
}
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
    [self.tab_Bottom reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}
// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText momentCell:(MomentCell *)cell
{
    NSLog(@"点击高亮文字：%@",linkText);
}
//评论
-(void)didCommentMoment:(MomentCell *)cell{
    NSLog(@"%ld",(long)cell.tag);
    if (!self.comment) {
        [self setComment];
    }
    self.comment.textField.text = @"";
    [self.comment.textField becomeFirstResponder];
    _CurrentTag = cell.tag;
}
-(void)setComment{
    self.comment = [[CommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
    self.comment.placeHolder = @"请输入评论内容";
    self.comment.btnTitle = @"评论";
    self.comment.delegate = self;
    [KWindowView addSubview:self.comment];
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
    chatViewController.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
}
//点击用户当前的资料
-(void)headImageClick{
    UserMo * mo = [UserMo new];
    if (self.user!=nil) {
        mo = self.user;
    }else{
        privateUserInfoModel * user = (privateUserInfoModel *)[YSAccountTool userInfo];
        mo.ID = user.modelId;
        mo.backgroundImage = user.backgroundImage;
        mo.nickName = user.nickName;
        mo.headImage = user.headImage;
    }
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.connectionMo = mo;
    [self.navigationController pushViewController:person animated:YES];
}
- (NSMutableArray *)momentList
{
    if (!_momentList) {
        _momentList = [[NSMutableArray alloc] init];
    }
    return _momentList;
}
@end
