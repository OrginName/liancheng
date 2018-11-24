//
//  RecommendController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "RecommendController.h"
#import "SDCycleScrollView.h"
#import "TXScrollLabelView.h"
#import "HeadView.h"
#import "RecommendTopCell.h"
#import "MiddleCell.h"
@interface RecommendController()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) MyTab * tab_Bottom;
@property (nonatomic,strong) NSMutableArray * lunArr;
@end
@implementation RecommendController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tab_Bottom registerClass:[HeadView class] forHeaderFooterViewReuseIdentifier:@"HeadView"];
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
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==1||section==2) {
        return 1;
    }
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        RecommendTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTopCell"];
        if (!cell) {
            cell = [[RecommendTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendTopCell"];
        }
        return cell;
    }else if (indexPath.section==1){
        MiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MiddleCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MiddleCell" owner:nil options:nil][0];
        }
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 195;
    }else if (indexPath.section==1){
        return ((self.tab_Bottom.width-30)/2*2);
    }
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeadView * head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeadView"];
     return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<3) {
        return 40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
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
    
    UIImageView * lc = [[UIImageView alloc] initWithFrame:CGRectMake(10, 195, 100, 40)];
    lc.image = [UIImage imageNamed:@"lctt"];
    [view_Bottom addSubview:lc];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-20, 205, 10, 15)];
    rightImage.image = [UIImage imageNamed:@"arraw-right"];
    [view_Bottom addSubview:rightImage];
    
    NSString *scrollTitle = @"测试测试测试测试";
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:TXScrollLabelViewTypeFlipRepeat velocity:2 options:UIViewAnimationOptionTransitionNone];
    //    scrollLabelView.scrollLabelViewDelegate = self;
    scrollLabelView.scrollInset = UIEdgeInsetsMake(0, -100, 0, 0);
    scrollLabelView.scrollTitleColor = YSColor(40, 40, 40);
    scrollLabelView.font = [UIFont systemFontOfSize:15];
    scrollLabelView.backgroundColor = [UIColor whiteColor];
    scrollLabelView.frame = CGRectMake(120, 190, kScreenWidth-150, 50);
    [view_Bottom addSubview:scrollLabelView];
    [scrollLabelView beginScrolling];
 
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
