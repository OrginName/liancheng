//
//  RecommendController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "RecommendController.h"
#import "SDCycleScrollView.h"
@interface RecommendController()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) MyTab * tab_Bottom;
@property (nonatomic,strong) NSMutableArray * lunArr;
@end
@implementation RecommendController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self setUI];
}
-(void)initData{
    self.lunArr = [NSMutableArray array];
    [self.lunArr addObjectsFromArray:[NSArray arrayWithObjects:@"http://img18.3lian.com/d/file/201709/21/f498e01633b5b704ebfe0385f52bad20.jpg",@"http://photo.16pic.com/00/04/73/16pic_473516_b.jpg",@"http://5b0988e595225.cdn.sohucs.com/images/20170826/b6fc1b92d3384f7f96a0e7a7e073d579.jpeg", nil]];
}
-(void)setUI{
    [self.view addSubview:self.tab_Bottom];
    [self initScroll];
}
#pragma mark ---------UITableviewDelegate----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    return cell;
}
#pragma mark --------SDCycleScrollViewDelegate--------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark ---initUI--------
-(void)initScroll{
    UIView * view_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tab_Bottom.width, 250)];
    self.tab_Bottom.tableHeaderView = view_Bottom;
    
    WeakSelf
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10, view_Bottom.width-20, 150) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.layer.cornerRadius = 10;
    cycleScrollView.layer.masksToBounds = YES;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = YES;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"no-pic"];
    [view_Bottom addSubview:cycleScrollView];
    //--- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = weakSelf.lunArr;
    });
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, self.tab_Bottom.width, 10)];
    view1.backgroundColor = YSColor(242, 243, 244);
    [view_Bottom addSubview:view1];
    
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 240, self.tab_Bottom.width, 10)];
    view2.backgroundColor = YSColor(242, 243, 244);
    [view_Bottom addSubview:view2];
    
}
#pragma mark ----懒加载UI------
-(MyTab *)tab_Bottom{
    if (!_tab_Bottom) {
        _tab_Bottom = [[MyTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-153)];
        _tab_Bottom.delegate = self;
        _tab_Bottom.dataSource = self;
        _tab_Bottom.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tab_Bottom;
}
@end
