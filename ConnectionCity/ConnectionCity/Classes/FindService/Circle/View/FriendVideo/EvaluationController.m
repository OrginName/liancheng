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
@interface EvaluationController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;
@property (nonatomic,strong)NSMutableArray * array;
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
}
-(void)setUI{
    self.array = [NSMutableArray array];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
}
-(void)initData{
    [CircleNet requstCircleDetail:@{@"id":self.moment.ID} withSuc:^(NSMutableArray *successArrValue) {
        self.array = successArrValue;
        [self.tab_bottom reloadData];
    }];
}
-(void)ClearAll{
//    [YTAlertUtil showTempInfo:@"清空"];
    [YSNetworkTool POST:v1ServiceCircleDelete params:@{@"id":self.moment.ID} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.block();
        [YTAlertUtil showTempInfo:@"删除成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
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
        [self becomeFirstResponder];
        CGPoint location = [longRecognizer locationInView:self.tab_bottom];
        NSIndexPath * indexPath = [self.tab_bottom indexPathForRowAtPoint:location];
        CircleCell * cell = (CircleCell *)longRecognizer.view;
        [cell becomeFirstResponder];
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(handleCopyCell:)];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy, itDelete,  nil]];
        [menu setTargetRect:cell.frame inView:self.view];
        [menu setMenuVisible:YES animated:YES];
        //可以得到此时你点击的哪一行
        NSLog(@"%lu",indexPath.row);
        //在此添加你想要完成的功能
    }
}
-(void)handleCopyCell:(id)sender{
    NSLog(@"我是回复");
}
-(void)handleDeleteCell:(id)sender{
    NSLog(@"我是删除");
}
@end
