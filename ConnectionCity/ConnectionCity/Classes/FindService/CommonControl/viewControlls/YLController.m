//
//  YLController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "YLController.h"
#import "YCLayout.h"
#import "TrvalTripCell.h"
#import "ShowResumeController.h"
#import "PersonNet.h"
@interface YLController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) YCLayout * flowLyout;
@property (nonatomic,strong)NSMutableArray * data_Arr;
@property (nonatomic,assign) NSInteger page;
@end

@implementation YLController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    self.data_Arr = [NSMutableArray array];
    [self.bollec_bottom registerNib:[UINib nibWithNibName:@"TrvalTripCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TripCell"];
    [self.view addSubview:self.bollec_bottom];
    [self initData];
    [self loadData];
}
-(void)initData{
    self.bollec_bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadData];
    }];
    self.bollec_bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}
-(void)loadData{
    NSDictionary * dic = @{
                            @"channelId": @"1",
                            @"pageNumber": @(_page),
                            @"pageSize": @(15),
                            @"userId":self.userID
                            };
    [PersonNet requstPersonYL:dic withArr:^(NSMutableArray * _Nonnull successArrValue) {
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self.data_Arr addObjectsFromArray:successArrValue];
        [self.bollec_bottom reloadData];
        [self.bollec_bottom.mj_header endRefreshing];
        [self.bollec_bottom.mj_footer endRefreshing];
    }];
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data_Arr count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/// collectinView section header 在高版本存在系统BUG，需要设置zPosition = 0.0
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrvalTripCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TripCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.mo_receive = self.data_Arr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{ 
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTrval;
    show.data_Count = self.data_Arr;
    show.zIndex = indexPath.row;
    show.flag = @"3";
    show.str = @"TrvalTrip";
    [self.navigationController pushViewController:show animated:YES];
}
-(UICollectionView *)bollec_bottom{
    if (!_bollec_bottom) {
        self.flowLyout = [[YCLayout alloc] init];
        _bollec_bottom = [[UICollectionView  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:self.flowLyout];
        _bollec_bottom.backgroundColor = [UIColor whiteColor];
        _bollec_bottom.delegate = self;
        _bollec_bottom.dataSource = self;
    }
    return _bollec_bottom;
} 
@end

