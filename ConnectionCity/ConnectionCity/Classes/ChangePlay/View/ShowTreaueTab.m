//
//  ShowTreaueTab.m
//  ConnectionCity
//
//  Created by qt on 2018/5/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowTreaueTab.h"
#import "ShowtreaureCell.h"
@interface ShowTreaueTab()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * lunArr;//轮播图数组
@property (nonatomic,strong) UITableView * tab_Bottom;
@property (nonatomic, strong)UIButton * btn_Like;
@property (nonatomic, strong)UIButton * Save_Like;
@end
@implementation ShowTreaueTab
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tab_Bottom];
        [self initScroll];
        [self initData];
    }
    return self;
}
-(void)initData{
    self.lunArr = [NSMutableArray arrayWithObjects:@"http://img.zcool.cn/community/0381de85949053ca8012193a3339cc5.jpg",@"http://img5.duitang.com/uploads/item/201411/06/20141106104720_WHEe2.jpeg",@"http://i3.17173cdn.com/2fhnvk/YWxqaGBf/outcms/xshCTvblpjznrmb.png",@"http://img.zcool.cn/community/01fd9f578f21a00000018c1b9a11ee.jpg@1280w_1l_2o_100sh.jpg", nil];
}
#pragma mark ---SDCycleScrollViewDelegate-----
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark --UITableviewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 76;
    }else if (indexPath.row==1){
        return 135;
    }else
        return 200;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowtreaureCell *cell = [ShowtreaureCell tempTableViewCellWith:tableView indexPath:indexPath];
    return cell;
}
#pragma mark ---initUI--------
-(void)initScroll{
    __block ShowTreaueTab * weakSelf = self;
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = YES;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    self.cycleScrollView = cycleScrollView;
    self.tab_Bottom.tableHeaderView = cycleScrollView;
    //                --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = weakSelf.lunArr;
    });
    [cycleScrollView addSubview:self.btn_Like];
    [cycleScrollView addSubview:self.Save_Like];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tab_Bottom.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.cycleScrollView.frame = CGRectMake(0, 0, self.tab_Bottom.width, self.tab_Bottom.width*0.8);
}
-(UITableView *)tab_Bottom{
    if (!_tab_Bottom) {
        _tab_Bottom = [[UITableView alloc] init];
        _tab_Bottom.delegate = self;
        _tab_Bottom.dataSource = self;
        _tab_Bottom.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tab_Bottom;
}
-(NSMutableArray *)lunArr{
    if (!_lunArr) {
        _lunArr = [[NSMutableArray alloc] init];
    }
    return _lunArr;
}
#warning 收藏按钮选中和未选中图片记得更换
-(UIButton *)Save_Like{
    if (!_Save_Like) {
        _Save_Like = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 60, 30, 40)];
        _Save_Like.backgroundColor = [UIColor whiteColor];
        _Save_Like.layer.cornerRadius = 5;
        [_Save_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
        [_Save_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
        _Save_Like.titleLabel.font = [UIFont systemFontOfSize:13];
        [_Save_Like setTitle:@"12" forState:UIControlStateNormal];
        [_Save_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
        [_Save_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
        [_Save_Like addTarget:self action:@selector(SaveClick:) forControlEvents:UIControlEventTouchUpInside];
        [_Save_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    return _Save_Like;
}
//点赞按钮点击
-(void)likeClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
//收藏按钮点击
-(void)SaveClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(UIButton *)btn_Like{
    if (!_btn_Like) {
        _btn_Like = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 10, 30, 40)];
        _btn_Like.backgroundColor = [UIColor whiteColor];
        _btn_Like.layer.cornerRadius = 5;
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
        _btn_Like.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn_Like setTitle:@"12" forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
        [_btn_Like addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    return _btn_Like;
}
@end
