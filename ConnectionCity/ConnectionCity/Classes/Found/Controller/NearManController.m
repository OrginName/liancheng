//
//  NearManController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
#import "NearManController.h"
#import "NearManCell.h"
#import "ConnectionMo.h"
#import "UserMo.h"
@interface NearManController ()
{
    int _page;
}
@property (weak, nonatomic) IBOutlet MyCollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray * data_Arr;
@end

@implementation NearManController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    _page=1;
    [self reloadData:@""];
}
//刷新数据
-(void)reloadData:(NSString *)flag{
    NSDictionary * dic = @{
                           @"gender": flag,
                           @"lat": @([[KUserDefults objectForKey:kLat] floatValue]),
                           @"lng": @([[KUserDefults objectForKey:KLng] floatValue]),
                           @"pageNumber": @(_page),
                           @"pageSize": @15
                           };
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadData:dic];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:dic];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonClick) image:@"our-more" title:nil EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.title = @"附近的人";
    [self.collectionView registerNib:[UINib nibWithNibName:@"NearManCell" bundle:nil] forCellWithReuseIdentifier:@"NearManCell"];
    // 设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 定义大小
    layout.itemSize = CGSizeMake((kScreenWidth - 30)/2, 227);
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 10;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data_Arr.count;
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NearManCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NearManCell" forIndexPath:indexPath];
    cell.mo = self.data_Arr[indexPath.row];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 30)/2, 227);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark - 点击事件
- (void)rightBarButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"只看女生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.data_Arr removeAllObjects];
        [self reloadData:@"0"];
        [self.collectionView.mj_header beginRefreshing];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"只看男生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.data_Arr removeAllObjects];
        [self reloadData:@"1"];
        [self.collectionView.mj_header beginRefreshing];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"查看全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.data_Arr removeAllObjects];
        [self reloadData:@""];
        [self.collectionView.mj_header beginRefreshing];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)loadData:(NSDictionary *)dic{
    [YSNetworkTool POST:v1PrivateUserNearbyList params:dic showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"data"][@"content"] count]==0) {
            [self endRefesh];
            return;
        }
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        self.data_Arr = [UserMo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"content"]];
        [self.collectionView reloadData];
        [self endRefesh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefesh];
    }];
}
-(void)endRefesh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
@end
