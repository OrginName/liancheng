//
//  VideoController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "VideoController.h"
#import "FriendVideoCell.h"
#import "MommentPlayerController.h"
#import "VideoLayout.h"
#import "PersonNet.h"
#import <IQKeyboardManager.h>
@interface VideoController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray * data_Arr;
@property (nonatomic,assign) NSInteger page;
@end

@implementation VideoController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.data_Arr = [NSMutableArray array];
    self.coll_Bottom.collectionViewLayout = [[VideoLayout alloc] init];
    [self.coll_Bottom registerNib:[UINib nibWithNibName:@"FriendVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VideoCell"];
    _page = 1;
    [self defultData:@[]];
    [self initData];
   
}
-(void)defultData:(NSArray *)arr{
    if (arr.count!=0) {
        [self.data_Arr addObjectsFromArray:arr];
        [self.coll_Bottom reloadData];
    }
}
//初始化数据
-(void)initData{
    self.coll_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadDataFriendList];
    }];
    self.coll_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFriendList];
    }];
    [self loadDataFriendList];
}
//加载朋友圈列表
-(void)loadDataFriendList{
    NSDictionary * dic = @{
                           @"containsImage": @0,
                           @"containsVideo": @1,
                           @"pageNumber": @(_page),
                           @"pageSize": @15,
                           @"userId": self.userID
                           };
    [PersonNet requstPersonVideo:dic withArr:^(NSMutableArray * _Nonnull successArrValue) {
        if (_page==1) {
            [self.data_Arr removeAllObjects];
        }
        _page++;
        [self.coll_Bottom.mj_header endRefreshing];
        [self.coll_Bottom.mj_footer endRefreshing];
        [self.data_Arr addObjectsFromArray:successArrValue];
        [self.coll_Bottom reloadData];
    } FailDicBlock:^(NSError * _Nonnull failValue) {
        [self.coll_Bottom.mj_header endRefreshing];
        [self.coll_Bottom.mj_footer endRefreshing];
    }];
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data_Arr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
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
        [self.coll_Bottom reloadData];
    };
    [self.navigationController pushViewController:moment animated:YES];
}
@end
