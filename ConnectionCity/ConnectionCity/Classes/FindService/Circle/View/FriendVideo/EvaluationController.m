//
//  EvaluationController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EvaluationController.h"
#import "CircleCell.h"
#import "CircleNet.h"
#import "Moment.h"
#import "CommentView.h"
#import <IQKeyboardManager.h>
#import "privateUserInfoModel.h"
@interface EvaluationController ()<UITableViewDelegate,UITableViewDataSource,CommentViewDelegate>{
    NSInteger CurrentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong)NSMutableArray * array;
@property (nonatomic,strong)CommentView * comment;
@end

@implementation EvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self setUI];
    if (self.service==nil) {
        [self initData];
    }else{
        self.array = [self.service.obj.commentList mutableCopy];
        [self.tab_bottom reloadData];
    }
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)setUI{
    self.array = [NSMutableArray array];
    NSString * str = @"";
    if (self.service!=nil) {
        str = self.service.obj.user.ID;
    }else{
        str = self.moment.userMo.ID;
    }
    if ([str isEqualToString:[[YSAccountTool userInfo]modelId]]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
    }
    [self setComment];
    CurrentIndex = 0;
}
-(void)initData{
    [CircleNet requstCircleDetail:@{@"id":self.moment.ID} withSuc:^(NSMutableArray *successArrValue) {
        self.array = successArrValue;
        [self.tab_bottom reloadData];
    }];
}
-(void)ClearAll{
    [YSNetworkTool POST:v1ServiceCircleDelete params:@{@"id":self.moment.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.block();
        [YTAlertUtil showTempInfo:@"删除成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.service!=nil) {
        ObjComment * obj = self.array[indexPath.row];
        return obj.cellHeight;
    }else{
        Comment * obj = self.array[indexPath.row];
        return obj.cellHeight;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:nil options:nil][0];
    }
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    if (self.service!=nil) {
        cell.mo = self.array[indexPath.row];
    }else
    cell.moment = self.array[indexPath.row];
    return cell;
}
-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        NSString * str = @"";
        if (self.service!=nil) {
            str = self.service.obj.user.ID;
        }else{
            str = self.moment.userMo.ID;
        }
        if ([str isEqualToString:[[YSAccountTool userInfo]modelId]]) {
            [self becomeFirstResponder];
            CGPoint location = [longRecognizer locationInView:self.tab_bottom];
            NSIndexPath * indexPath = [self.tab_bottom indexPathForRowAtPoint:location];
            CircleCell * cell = (CircleCell *)longRecognizer.view;
            [cell becomeFirstResponder];
            if (self.service!=nil) {
                ObjComment * obj = self.array[indexPath.row];
                [self setMenItem:obj.replyList cell:cell];
            }
            CurrentIndex = indexPath.row;
        }
    }
}
-(void)setMenItem:(NSArray *)arr cell:(CircleCell *)cell{
    UIMenuItem *itCopy;
    UIMenuItem *itDelete;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (arr.count!=0) {
        itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        [menu setMenuItems:@[itDelete]];
    }else{
        itCopy = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(handleCopyCell:)];
        itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        [menu setMenuItems:@[itCopy,itDelete]];
    }
    [menu setTargetRect:cell.frame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
}
-(void)handleCopyCell:(id)sender{
    self.comment.textField.text = @"";
    [self.comment.textField becomeFirstResponder];
}
-(void)handleDeleteCell:(id)sender{
    [YTAlertUtil showTempInfo:@"我是删除"];
}
#pragma mark -----CommentViewDelegate------
- (void)sendValue{
    if (self.service!=nil) {
        ObjComment * obj = self.array[CurrentIndex];
        [self reply:obj.ID];
    }else{
        Moment * mo = self.array[CurrentIndex];
        [self reply:mo.ID];
    }
}
-(void)reply:(NSString *)ID{
    NSDictionary * dic1 = @{
                            @"commentId": @([ID integerValue]),
                            @"content": self.comment.textField.text
                            };
    [YSNetworkTool POST:v1CommonCommentReplay params:dic1 showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        ObjComment * obj = self.array[CurrentIndex];
        NSMutableArray * arr = [NSMutableArray array];
        [arr addObject:responseObject[@"data"]];
        obj.replyList = [arr copy];
        [self.array replaceObjectAtIndex:CurrentIndex withObject:obj];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.comment.textField resignFirstResponder];
            [self.tab_bottom reloadData];
        }); 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.comment removeFromSuperview];
}
-(void)setComment{
    self.comment = [[CommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 40)];
    self.comment.placeHolder = @"请输入回复内容";
    self.comment.btnTitle = @"回复";
    self.comment.delegate = self;
    [KWindowView addSubview:self.comment];
}
@end
