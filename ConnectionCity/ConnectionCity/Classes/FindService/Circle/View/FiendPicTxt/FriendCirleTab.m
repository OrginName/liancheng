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
#import "PersonalBasicDataController.h"
#import "TakePhoto.h"
#import "QiniuUploader.h"
#import "PersonalBasicDataController.h"
#import "UIView+Geometry.h"
@interface FriendCirleTab()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate,CommentViewDelegate>
{ 
    NSInteger _CurrentTag;
    NSString * _cityCode;
}
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) NSMutableArray *momentList;
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendCirleTab
-(instancetype)initWithFrame:(CGRect)frame withControll:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.controller = control;
        _cityCode = @"";
        [self setUI];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
//        NSArray * arr = @[];
//        if ([self.flagStr isEqualToString:@"HomeSend"]){
//           arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"PICHOME"]];
//        }else
//           arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"PICTXT"]];
//        [self defultData:arr];
        [self initTestInfo];
        _page=1;
        _CurrentTag= 0;
        [self setComment];
        [self.mj_header beginRefreshing];
    }
    return self;
}
-(void)setUI{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
    self.dataSource = self;
}
#pragma mark -----CommentViewDelegate------
- (void)sendValue{
    [self btnClicked];
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
        [weakSelf reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
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
        [weakSelf loadDataFriendList:_cityCode];
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataFriendList:_cityCode];
    }];
//
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
-(void)loadDataFriendList:(NSString *)cityCode{
    _cityCode = cityCode;
    NSString * code = [KUserDefults objectForKey:YCode]?[KUserDefults objectForKey:YCode]:@"";
    NSDictionary * dic = @{};
    if ([self.flagStr isEqualToString:@"HomeSend"]) {
        dic = @{
                @"pageNumber": @(_page),
                @"pageSize": @15
                };
    }else{
        dic = @{
                @"cityCode":code,
                @"containsImage": @1,
                @"containsVideo": @0,
                @"pageNumber": @(_page),
                @"pageSize": @15,
                @"userId": self.user.ID?self.user.ID:@""
                };
    }
    if (self.user!=nil) {
        self.flagStr = @"userFriend";
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
//        if ([self.flagStr isEqualToString:@"HomeSend"]) {
//            [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:weakSelf.momentList] forKey:@"PICHOME"];
//        }else
//        [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:weakSelf.momentList] forKey:@"PICTXT"];
        if (weakSelf.momentList.count!=0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf.tableHeaderView) {
                    // 通知主线程刷新 神马的
                    weakSelf.tableHeaderView = weakSelf.headImage;
                }
            });
        }
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
//    MomentCell *cell1 = (MomentCell *)cell;
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
        [weakSelf reloadData];
    };
    [self.controller.navigationController pushViewController:mom animated:YES];
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
    [self.controller.navigationController pushViewController:person animated:YES];
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
        [weakSelf reloadData];
    }];
}
// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSIndexPath * index = [self indexPathForCell:cell];
    [self reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
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
    [self.controller.navigationController pushViewController:chatViewController animated:YES];
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
    [self.controller.navigationController pushViewController:person animated:YES];
}
//更换图片
-(void)ChangePhoto{
    WeakSelf
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.headImage.image = image;
        });
        [YTAlertUtil showHUDWithTitle:@"正在更新..."];
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
            [YSNetworkTool POST:v1PrivateUserUpdate params:@{@"backgroundImage":[NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]]} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
                privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
                [YSAccountTool saveUserinfo:userInfoModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YTAlertUtil hideHUD];
                });
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YTAlertUtil hideHUD];
                });
            }];
        }];
    }];
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    //    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
} 
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width*0.8)];
        _headImage.userInteractionEnabled = YES;
        privateUserInfoModel * userInfo = [YSAccountTool userInfo];
        if (self.user!=nil) {
            [_headImage sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/400/h/400", self.user.backgroundImage)] placeholderImage:[UIImage imageNamed:@"2"]];
        }else
        [_headImage sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/400/h/400", userInfo.backgroundImage)] placeholderImage:[UIImage imageNamed:@"2"]];
        UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(_headImage.width-70, _headImage.height-30, 60, 60)];
        image1.tag = 999;
        if (self.user!=nil) {
            [image1 sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/50/h/50", self.user.headImage)] placeholderImage:[UIImage imageNamed:@"logo2"]];
        }else
        [image1 sd_setImageWithURL:[NSURL URLWithString:KString(@"%@?imageView2/1/w/50/h/50", userInfo.headImage)] placeholderImage:[UIImage imageNamed:@"logo2"]];
        image1.layer.cornerRadius = 5;
        image1.layer.masksToBounds = YES;
        image1.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageClick)];
        [image1 addGestureRecognizer:tap1];
        [_headImage addSubview:image1];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(image1.x-110, image1.y, 100, 25)];
        lab.text = self.user!=nil?self.user.nickName:userInfo.nickName;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:18];
        lab.textAlignment = NSTextAlignmentRight;
        if (self.user==nil||(self.user!=nil&&[[self.user.ID description] isEqualToString:[[YSAccountTool userInfo] modelId]])) {
            UILongPressGestureRecognizer * tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ChangePhoto)];
            [_headImage addGestureRecognizer:tap];
        }
        [_headImage addSubview:lab];
    }
    return _headImage;
}
@end
