//
//  FriendVideo.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendVideo.h"
#import "FriendVideoCell.h"
#import "MommentPlayerController.h"
#import "CircleNet.h"
#import "MommentPlayerController.h"
@interface FriendVideo()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
}
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendVideo
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withController:(UIViewController *)controller{
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        self.controller = controller;
        self.data_Arr = [NSMutableArray array];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.collectionViewLayout = [[FriendVideoLayout alloc] init];
        [self registerNib:[UINib nibWithNibName:@"FriendVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VideoCell"];
        self.delegate = self;
        self.dataSource = self;
        
        NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"VIDEO"]];
        [self defultData:arr];
        [self initData];
        _page = 1;
    }
    return self;
}
-(void)defultData:(NSArray *)arr{
    if (arr.count!=0) {
        [self.data_Arr addObjectsFromArray:arr];
        [self reloadData];
    }
}
//初始化数据
-(void)initData{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadDataFriendList];
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFriendList];
    }];
    [self.mj_header beginRefreshing];
}
//加载朋友圈列表
-(void)loadDataFriendList{
    NSDictionary * dic = @{
                           @"containsImage": @0,
                           @"containsVideo": @1,
                           @"pageNumber": @(_page),
                           @"pageSize": @15
                           };
    [CircleNet requstCirclelDic:dic withSuc:^(NSMutableArray *successArrValue) {
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [self.data_Arr addObjectsFromArray:successArrValue];
        [KUserDefults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.data_Arr] forKey:@"VIDEO"];
        [self reloadData];
    }FailErrBlock:^(NSError *failValue) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }];
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data_Arr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    FriendVideoCell * cell1 = (FriendVideoCell *)cell;
//   
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendVideoCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.moment = self.data_Arr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MommentPlayerController * moment = [MommentPlayerController new];
    moment.moment = self.data_Arr[indexPath.row];
    moment.block = ^{
        [self.data_Arr removeObjectAtIndex:indexPath.row];
        [self reloadData];
    };
    [self.controller.navigationController pushViewController:moment animated:YES];
}
@end
@implementation FriendVideoLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width-5)/ 2;
    self.itemSize = CGSizeMake(itemW, (self.collectionView.height-5)/2);
    //设置最小间距
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    self.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);
}
@end
