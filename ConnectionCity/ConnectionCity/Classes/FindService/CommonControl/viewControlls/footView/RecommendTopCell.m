//
//  RecommendTopCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "RecommendTopCell.h"
#import "TopCell.h"
#import "FJCell.h"
@class ReLayout;
@class FJLayout;
@implementation RecommendTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFlag:(NSString *)flag{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.flagStr = flag;
        [self.contentView addSubview:self.coll_Bottom];
        
        if ([flag isEqualToString:@"First"]) {
            [self.coll_Bottom registerNib:[UINib nibWithNibName:@"TopCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TopCell"];
        }else{
            [self.coll_Bottom registerNib:[UINib nibWithNibName:@"FJCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FJCell"];
            [self.contentView addSubview:self.view_Bottom];
        }
    }
    return self;
}
-(UICollectionView *)coll_Bottom{
    if (!_coll_Bottom) {
        ReLayout * flowLyout = [[ReLayout alloc] init];
        FJLayout * flowLayout1 = [[FJLayout alloc] init];
        _coll_Bottom = [[UICollectionView  alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, [self.flagStr isEqualToString:@"First"]?175:224) collectionViewLayout:[self.flagStr isEqualToString:@"First"]?flowLyout:flowLayout1];
        _coll_Bottom.showsHorizontalScrollIndicator = NO;
         _coll_Bottom.backgroundColor = [UIColor whiteColor];
        _coll_Bottom.delegate = self;
        _coll_Bottom.dataSource = self;
    }
    return _coll_Bottom;
}
-(UIView *)view_Bottom{
    if (!_view_Bottom) {
        _view_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, [self.flagStr isEqualToString:@"First"]?185:234, kScreenWidth, 10)];
        _view_Bottom.backgroundColor = YSColor(241, 242, 243);
    }
    return _view_Bottom;
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
    if ([self.flagStr isEqualToString:@"First"]) {
        TopCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TopCell" forIndexPath:indexPath];
        return cell;
    }else{
       FJCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"FJCell" forIndexPath:indexPath];
        return cell;
    }  
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
@implementation FJLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.width - 20)/ 2+5;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(itemW, 219);
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
}
@end
