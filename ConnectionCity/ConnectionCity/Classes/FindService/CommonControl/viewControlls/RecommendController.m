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
#import "ListCell.h"
#import "SecureController.h"
#import "TTController.h"
#import "NoticeView.h"
#import "PersonNet.h"
#import "ReceMo.h"
@interface RecommendController()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TXScrollLabelViewDelegate>
@property (nonatomic,strong) MyTab * tab_Bottom;
@property (nonatomic,strong) NSMutableArray * lunArr;
@property (nonatomic,strong) UIImageView * image_security;
@property (nonatomic,strong) NoticeView *noticeView;
@property (nonatomic,strong) ReceMo * receMo;
@end
@implementation RecommendController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    [self initData];
    [self.tab_Bottom registerClass:[HeadView class] forHeaderFooterViewReuseIdentifier:@"HeadView"];
}
-(void)initData{
    self.lunArr = [NSMutableArray array]; 
    WeakSelf
    NSDictionary * dic = @{
                           @"lat":@([[KUserDefults objectForKey:kLat] floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng] floatValue]),
                           @"pageNumber": @1,
                           @"pageSize": @5,
                           };
    [PersonNet requstTJGGArr:^(NSMutableArray *  successArrValue) {
        weakSelf.lunArr = successArrValue;
        [PersonNet requstTJArr:dic withArr:^(ReceMo *mo) {
            weakSelf.receMo = mo;
            NSLog(@"%ld",weakSelf.receMo.hotServiceList.count);
            [weakSelf.tab_Bottom reloadData];
        } FailDicBlock:nil];
    } FailDicBlock:nil];
}
-(void)setUI{
    [self.view addSubview:self.tab_Bottom];
    [self initScroll];
    [self.view addSubview:self.image_security];
    [self.view addSubview:self.noticeView];
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
    if (indexPath.section==0||indexPath.section==2) {
        RecommendTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTopCell"];
        NSString * str = indexPath.section==0?@"First":@"Third";
        if (!cell) {
            cell = [[RecommendTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendTopCell" withFlag:str];
        }
        cell.arr_Data = indexPath.section==0?[self.receMo.hotServiceList mutableCopy]:[self.receMo.nearbyPage mutableCopy];
        return cell;
    }else if (indexPath.section==1){
        MiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MiddleCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MiddleCell" owner:nil options:nil][0];
        }
        cell.arr = [self.receMo.activityList mutableCopy];
        return cell;
    }
    ListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil][0];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 195;
    }else if (indexPath.section==1){
        return ((kScreenWidth-30)*0.5*1.2*0.5)*2+40;
    }else if (indexPath.section==2){
        return 244;
    } 
    return 327;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeadView * head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeadView"];
    NSArray * arr = @[@"同城热约",@"限时活动",@"附近动态"];
    head.lab_title.text = arr[section];
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
#pragma mark ----secClick--------
-(void)secClick{ 
    //弹出ViewController
    SecureController *xVC = [SecureController new];
    //设置ViewController的背景颜色及透明度
    xVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:xVC];
    //设置ViewController的模态模式，即ViewController的显示方式
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.view.backgroundColor = [UIColor clearColor];
    //加载模态视图
    [self presentViewController:nav animated:YES completion:^{
    }];
}
#pragma mark --------SDCycleScrollViewDelegate--------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    TTController * tt = [TTController new];
    tt.title = @"连程头条";
    [self.navigationController pushViewController:tt animated:YES];
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
    scrollLabelView.scrollLabelViewDelegate = self;
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
        _tab_Bottom = [[MyTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-213)];
        _tab_Bottom.delegate = self;
        _tab_Bottom.dataSource = self;
        _tab_Bottom.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tab_Bottom;
}
-(UIImageView *)image_security{
    if (!_image_security) {
        _image_security = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-25)/2, 100, 45)];
        _image_security.image = [UIImage imageNamed:@"secure"];
        _image_security.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secClick)];
        [_image_security addGestureRecognizer:tap];
    }
    return _image_security;
}
-(NoticeView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tab_Bottom.frame)+10, kScreenWidth, 50) controller:self];
    }
    return _noticeView;
}
@end
