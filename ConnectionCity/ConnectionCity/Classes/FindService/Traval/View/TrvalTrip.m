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
@interface TrvalTrip()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * bollec_bottom;
@property (nonatomic,strong)TrvalTripLayout * flowLyout;
@property (nonatomic,strong)UIViewController * control;
@end
@implementation TrvalTrip
-(instancetype)initWithFrame:(CGRect)frame withControl:(UIViewController *)control{
    if (self = [super initWithFrame:frame]) {
        self.control = control;
        [self addSubview:self.bollec_bottom];
        [self.bollec_bottom registerNib:[UINib nibWithNibName:@"TrvalTripCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TripCell"];
    }
    return self;
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TrvalTripCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TripCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.control.navigationController pushViewController:[AppointmentController new] animated:YES];
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
