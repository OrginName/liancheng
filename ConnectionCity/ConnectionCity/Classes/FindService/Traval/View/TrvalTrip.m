//
//  TrvalTrip.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalTrip.h"
#import "TrvalTripCell.h"
#import "AppointmentController.h"
#import "ServiceHomeNet.h"
#import "ShowResumeController.h"
@interface TrvalTrip()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)TrvalTripLayout * flowLyout;
@property (nonatomic,strong)UIViewController * control;
@end
@implementation TrvalTrip
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.control = control;
        [self addSubview:self.bollec_bottom];
        _page=1;
        self.cityID = [KUserDefults objectForKey:kUserCityID];
        self.data_Arr = [NSMutableArray array];
        [self.bollec_bottom registerNib:[UINib nibWithNibName:@"TrvalTripCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TripCell"];
        [self initData];
        [self.bollec_bottom.mj_header beginRefreshing];
    }
    return self;
}
-(void)initData{
    self.bollec_bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadData:@{@"cityID":self.cityID}];
    }];
    self.bollec_bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:@{@"cityID":self.cityID}];
    }];
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    _page=1;
    [self loadData:@{
                     @"cityID":self.cityID,
                     @"age":dic[@"0"],
                     @"distance":dic[@"1"],
                     @"gender":dic[@"2"],
                     @"userStatus":dic[@"10"],
                     @"validType":dic[@"3"]
                     }];
}
-(void)loadData:(NSDictionary *)dic{
    NSDictionary * dic1 = @{
                            @"age": dic[@"age"]?dic[@"age"]:@"",
                            @"cityCode": @([dic[@"cityID"] integerValue]),
                            @"distance": dic[@"distance"]?dic[@"distance"]:@"",
                            @"gender": dic[@"gender"]?dic[@"gender"]:@"",
                            @"lat": @([[KUserDefults objectForKey:kLat]floatValue]),
                            @"lng": @([[KUserDefults objectForKey:KLng]floatValue]),
                            @"pageNumber": @(_page),
                            @"pageSize": @15,
                            @"userStatus": dic[@"userStatus"]?dic[@"userStatus"]:@"",
                            @"validType": dic[@"validType"]?dic[@"validType"]:@""
                            };
    [ServiceHomeNet requstTrvalInvitDic:dic1 withSuc:^(NSMutableArray *successArrValue) {
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrvalTripCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TripCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.mo_receive = self.data_Arr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self.control.navigationController pushViewController:[AppointmentController new] animated:YES];
    ShowResumeController * show = [ShowResumeController new];
    show.Receive_Type = ENUM_TypeTrval;
    show.data_Count = self.data_Arr;
    show.zIndex = indexPath.row;
    show.str = @"TrvalTrip";
    [self.control.navigationController pushViewController:show animated:YES]; 
}
-(UICollectionView *)bollec_bottom{
    if (!_bollec_bottom) {
        self.flowLyout = [[TrvalTripLayout alloc] init];
        _bollec_bottom = [[UICollectionView  alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLyout];
        _bollec_bottom.backgroundColor = [UIColor whiteColor];
        _bollec_bottom.delegate = self;
        _bollec_bottom.dataSource = self;
    }
    return _bollec_bottom;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bollec_bottom.frame = CGRectMake(0, 0, self.width, self.height);
}
@end
@implementation TrvalTripLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 30)/ 2;
    self.itemSize = CGSizeMake(itemW, 200);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
}
@end
