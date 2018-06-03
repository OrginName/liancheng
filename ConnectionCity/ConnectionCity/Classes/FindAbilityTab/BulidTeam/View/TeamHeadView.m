//
//  TeamHeadView.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TeamHeadView.h"
#import "TeamCollectionCell.h"

@implementation TeamHeadView

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
- (void)layoutSubviews {
    [self setUI];
}
#pragma mark - setup
- (void)setUI {
    [_collectionView registerNib:[UINib nibWithNibName:@"TeamCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TeamCollectionCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_collectionView setCollectionViewLayout:flowLayout];
}
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeamCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TeamCollectionCell" forIndexPath:indexPath];
    return cell;
}
//#pragma mark  定义每个UICollectionView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return  CGSizeMake(kScreenWidth / 3,kScreenWidth / 3);
//}
//#pragma mark  定义整个CollectionViewCell与整个View的间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    //（上、左、下、右）
//    return UIEdgeInsetsMake(0, 0, (10 / 3 - 2) * kScreenWidth / 3, 0);
//}
//#pragma mark  定义每个UICollectionView的横向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}
//#pragma mark  定义每个UICollectionView的纵向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}
//#pragma mark  点击CollectionView触发事件
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"---------------------");
//}
//#pragma mark  设置CollectionViewCell是否可以被点击
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

