//
//  SearchCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SearchCell.h"
#import <Masonry.h>
#import "SearchLayout.h"
#import "SearchCollectionCell.h"
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
NSString * const SearchCellDidChangeNotification = @"SearchCellDidChangeNotification";
static NSString *ID = @"SearchCollectionCell";
@interface SearchCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation SearchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.collectionView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth-20, self.height);
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, self.height) collectionViewLayout:[[SearchLayout alloc] init]];
        [_collectionView registerClass:[SearchCollectionCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (void)setCityNameArray:(NSArray *)cityNameArray {
    _cityNameArray = cityNameArray;
    [_collectionView reloadData];
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.title = _cityNameArray[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cityName = _cityNameArray[indexPath.row];
    NSDictionary *cityNameDic = @{@"cityName":cityName};
    [[NSNotificationCenter defaultCenter] postNotificationName:SearchCellDidChangeNotification object:self userInfo:cityNameDic];
}
@end
