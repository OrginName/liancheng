//
//  JFCityTableViewCell.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityTableViewCell.h"
#import "CityMo.h"
#import "Masonry.h"
#import "JFCityCollectionFlowLayout.h"
#import "JFCityCollectionViewCell.h"
#define JFRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
static NSString *ID = @"cityCollectionViewCell";
@interface JFCityTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JFCityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews]; 
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[JFCityCollectionFlowLayout alloc] init]];
        [_collectionView registerClass:[JFCityCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (void)setCityNameArray:(NSMutableArray *)cityNameArray {
    _cityNameArray = cityNameArray;
    NSUInteger height = 44;
    if (0 == (_cityNameArray.count % 3)) {
        height = _cityNameArray.count / 3 * 50;
    }else {
        height = (_cityNameArray.count / 3 + 1) * 50;
    }
    if (height > 300) {
        height = 300;
    }
    _collectionView.height = height;
    _collectionView.width = kScreenWidth - 50;
    [_collectionView reloadData];
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    CityMo * mo = _cityNameArray[indexPath.row];
    cell.title = mo.name;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CityMo * mo = _cityNameArray[indexPath.row];
    NSDictionary *cityNameDic = @{@"cityName":mo.name,@"ID":mo.ID,@"lat":mo.lat,@"lng":mo.lng};
    [[NSNotificationCenter defaultCenter] postNotificationName:JFCityTableViewCellDidChangeCityNotification1 object:self userInfo:cityNameDic];
}


@end
