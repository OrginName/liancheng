//
//  RecommendTopCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "RecommendTopCell.h"
#import "TopCell.h"
@class ReLayout;
@implementation RecommendTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coll_Bottom];
        [self.coll_Bottom registerNib:[UINib nibWithNibName:@"TopCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TopCell"];
    }
    return self;
}
-(UICollectionView *)coll_Bottom{
    if (!_coll_Bottom) {
        ReLayout * flowLyout = [[ReLayout alloc] init];
        _coll_Bottom = [[UICollectionView  alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 175) collectionViewLayout:flowLyout];
        _coll_Bottom.showsHorizontalScrollIndicator = NO;
         _coll_Bottom.backgroundColor = [UIColor whiteColor];
        _coll_Bottom.delegate = self;
        _coll_Bottom.dataSource = self;
    }
    return _coll_Bottom;
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TopCell" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.mo_receive = self.data_Arr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
@implementation ReLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.width - 20)/ 3;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(itemW, 170);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
}
@end
