//
//  FollowHeadView.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FollowHeadView.h"
#import "FollwCollectionViewCell.h"
@class FollowLayout;
@implementation FollowHeadView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.coll_Bottom];
        [self addSubview:self.view_line];
        [self.coll_Bottom registerNib:[UINib nibWithNibName:@"FollwCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FollwCollectionViewCell"];
    }
    return self;
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
    FollwCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"FollwCollectionViewCell" forIndexPath:indexPath];
    return cell;
    return [UICollectionViewCell new];
}
-(UICollectionView *)coll_Bottom{
    if (!_coll_Bottom) {
         FollowLayout * flowLayout1 = [[FollowLayout alloc] init];
        _coll_Bottom = [[UICollectionView  alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, (kScreenWidth-20)/5+25) collectionViewLayout:flowLayout1];
        _coll_Bottom.showsHorizontalScrollIndicator = NO;
        _coll_Bottom.backgroundColor = [UIColor whiteColor];
        _coll_Bottom.delegate = self;
        _coll_Bottom.dataSource = self;
    }
    return _coll_Bottom;
}
-(UIView *)view_line{
    if (!_view_line) {
        _view_line = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-20)/5+25, kScreenWidth, 10)];
        _view_line.backgroundColor = YSColor(241, 242, 243);
    }
    return _view_line;
}
@end
@implementation FollowLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.width - 40)/ 5;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(itemW, itemW+25);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
}
@end
