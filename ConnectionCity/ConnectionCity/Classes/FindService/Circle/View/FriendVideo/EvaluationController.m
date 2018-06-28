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
@interface EvaluationController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;

@end

@implementation EvaluationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self setUI];
    [self initData];
}
-(void)setUI{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(ClearAll) image:@"" title:@"清空" EdgeInsets:UIEdgeInsetsZero];
}
-(void)initData{
    [CircleNet requstCircleDetail:@{@"id":self.moment.ID} withSuc:^(NSMutableArray *successArrValue) {
        
    }];
}
-(void)ClearAll{
    [YTAlertUtil showTempInfo:@"清空"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CircleCell0"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CircleCell" owner:nil options:nil][0];
    }
    return cell;
}
@end
