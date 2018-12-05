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
#import "TTController.h"
#import "NoticeView.h"
#import "PersonNet.h"
#import "ReceMo.h"
#import "ShowResumeController.h"
#import "serviceListNewMo.h"
#import "PersonalBasicDataController.h"

@interface RecommendController()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TXScrollLabelViewDelegate>
{
    SDCycleScrollView * _cy;
    NSInteger _page;
}
@property (nonatomic,strong) MyTab * tab_Bottom;
@property (nonatomic,strong) NSMutableArray * lunArr;
@property (nonatomic,strong) UIImageView * image_security;
@property (nonatomic,strong) NoticeView *noticeView;
@property (nonatomic,strong) ReceMo * receMo;
@property (nonatomic,strong) NSMutableArray * arr_TT;
@property (nonatomic,strong) NSMutableArray * arr_nearBy;
@property (nonatomic,strong) NSMutableArray * nearByArrP;
@end
@implementation RecommendController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    _page = 1;
    [self initData];
    [self.tab_Bottom registerClass:[HeadView class] forHeaderFooterViewReuseIdentifier:@"HeadView"];
}
-(void)initData{
    self.lunArr = [NSMutableArray array];
    self.arr_TT = [NSMutableArray array];
    self.arr_nearBy = [NSMutableArray array];
    self.nearByArrP = [NSMutableArray array];
    WeakSelf
    [PersonNet requstTJGGArr:^(NSMutableArray *  successArrValue) {
        weakSelf.lunArr = successArrValue;
        [weakSelf loadList];
    } FailDicBlock:nil];
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [weakSelf loadList];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadList];
    }];
}
-(void)loadList{
    NSDictionary * dic = @{
                           @"lat":@([[KUserDefults objectForKey:kLat] floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng] floatValue]),
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           };
    WeakSelf
    [PersonNet requstTJArr:dic withArr:^(ReceMo *mo) {
        weakSelf.receMo = mo;
        if (_page==1) {
            [weakSelf.arr_nearBy removeAllObjects];
        }
        _page++;
        [weakSelf.tab_Bottom.mj_header endRefreshing];
        [weakSelf.tab_Bottom.mj_footer endRefreshing];
        [weakSelf.arr_nearBy addObjectsFromArray:mo.circleList];
        [weakSelf.nearByArrP addObjectsFromArray:mo.nearbyPage];
        [weakSelf.tab_Bottom reloadData];
    } FailDicBlock:nil];
}
-(void)setUI{
    [self.view addSubview:self.tab_Bottom];
    [self initScroll];
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
    return self.arr_nearBy.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0||indexPath.section==2) {
        RecommendTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTopCell"];
        NSString * str = indexPath.section==0?@"First":@"Third";
        if (!cell) {
            cell = [[RecommendTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecommendTopCell" withFlag:str control:self];
        }
        cell.arr_Data = indexPath.section==0?[self.receMo.hotServiceList mutableCopy]:[self.nearByArrP mutableCopy];
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
    WeakSelf
    cell.mom = self.arr_nearBy[indexPath.row];
    cell.block = ^(ListCell *cell) {
        ShowResumeController * show = [ShowResumeController new];
        show.Receive_Type = ENUM_TypeTrval;
        show.flag = @"1";
        show.flagNext = @"NONext";
        NSMutableArray * arr = [NSMutableArray array];
        for (Moment * mo in weakSelf.arr_nearBy) {
            serviceListNewMo * mo1 = [serviceListNewMo new];
            mo1.ID = mo.userId;
            [arr addObject:mo1];
        }
        show.data_Count = arr;
        [weakSelf.navigationController pushViewController:show animated:YES];
    };
    cell.headBlcok = ^(ListCell *cell) {
        NSIndexPath * index = [self.tab_Bottom indexPathForCell:cell];
        Moment * mo = self.arr_nearBy[index.row];
        PersonalBasicDataController * base = [PersonalBasicDataController new];
        UserMo * user = [UserMo new];
        user.ID = mo.userId;
        base.connectionMo = user;
        [self.navigationController pushViewController:base animated:YES];
    };
    
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
    return 280;
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
#pragma mark --------SDCycleScrollViewDelegate--------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView.tag==200000) {
        TTController * tt = [TTController new];
        tt.title = @"连程头条";
        tt.arrReceive = self.arr_TT;
        [self.navigationController pushViewController:tt animated:YES];
    }
}
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    
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
    cycleScrollView.tag = 100000;
    cycleScrollView.autoScroll = YES;
//    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
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
 
    _cy = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(110, 190, kScreenWidth-140, 50) delegate:self placeholderImage:nil];
    _cy.backgroundColor = [UIColor whiteColor];
    _cy.scrollDirection = UICollectionViewScrollDirectionVertical;
    _cy.showPageControl = NO;
    _cy.tag = 200000;
    [view_Bottom addSubview:_cy];
    [PersonNet requstGZArr:^(NSMutableArray *successArrValue) {
        weakSelf.arr_TT = successArrValue;
        NSMutableArray * arr = [NSMutableArray array];
        for (int i=0;i<successArrValue.count;i++) {
            [arr addObject:@""];
        }
        _cy.imageURLStringsGroup = arr;
    } FailDicBlock:nil];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 240, self.tab_Bottom.width, 10)];
    view2.backgroundColor = YSColor(242, 243, 244);
    [view_Bottom addSubview:view2];
    
}
// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if (view != _cy) {
        return nil;
    }
    return [CustomCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    CustomCollectionViewCell *myCell = (CustomCollectionViewCell *)cell;
    TTMo * mo = self.arr_TT[index];
    if ([mo.type isEqualToString:@"10"]) {
        myCell.titleLabel.text = mo.XSStr;
        myCell.image1.hidden = YES;
        [myCell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
    }else{
       myCell.titleLabel.attributedText = mo.firstPart;
        myCell.image1.hidden = NO;
        [myCell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.providerHeadImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
        [myCell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mo.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
    }
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
-(NoticeView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tab_Bottom.frame)+10, kScreenWidth, 50) controller:self];
    }
    return _noticeView;
}
@end
@implementation CustomCollectionViewCell

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
     }
    return _titleLabel;
}
-(UIImageView *)image1{
    if (!_image1) {
        _image1 = [[UIImageView alloc] init];
        _image1.frame = CGRectMake(self.width-55, 10, 30, 30);
        _image1.layer.cornerRadius = _image1.width/2;
        _image1.image = [UIImage imageNamed:@"logo2"];
        _image1.layer.masksToBounds = YES;
    }
    return _image1;
}
-(UIImageView *)image2{
    if (!_image2) {
        _image2 = [[UIImageView alloc] init];
        _image2.frame = CGRectMake(self.width-30, 10, 30, 30);
        _image2.layer.cornerRadius = _image2.width/2;
        _image2.image = [UIImage imageNamed:@"moment_cover"];
        _image2.layer.masksToBounds = YES;
    }
    return _image2;
}
#pragma mark - 页面初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.image1];
    [self.contentView addSubview:self.image2];
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.width-55, 50);
}
@end
