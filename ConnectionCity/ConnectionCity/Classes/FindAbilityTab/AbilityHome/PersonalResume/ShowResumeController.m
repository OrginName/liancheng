//
//  ShowResumeController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowResumeController.h"
#import "ShowResumeTab.h"
#define identifier @"ScrollCell"
#define TabHeight kScreenHeight-185
@interface ShowResumeController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, assign)Boolean isFullScreen;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, assign)int currentIndex;
@property (nonatomic, strong)ShowResumeTab * showTab;
@end

@implementation ShowResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人简历";
    [self setUI];
}
-(void)setUI{
     self.imageArray = [NSMutableArray arrayWithArray:@[@"001.jpg",@"002.jpg",@"003.jpg"]];
    [self.view addSubview:self.collectionView];
}

#pragma mark --各种点击事件---
//导航栏完成按钮点击
-(void)complete{
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (self.Receive_Type == ENUM_TypeResume) {
        self.showTab = [[ShowResumeTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        NSLog(@"indexPath.row ====>%ld",(long)indexPath.row);
        [cell.contentView addSubview:self.showTab];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth-20, TabHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    if(_currentIndex == _imageArray.count-1){
        
    }
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        layout.minimumInteritemSpacing = 0.0f;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, TabHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.contentSize = CGSizeMake(kScreenWidth*self.imageArray.count, kScreenHeight);
        _collectionView.contentOffset = CGPointMake(0, 0);
    }
    return _collectionView;
}

//-(ShowResumeTab *)showTab{
//    if (!_showTab) {
//        _showTab = [[ShowResumeTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-70)];
//    }
//    return _showTab;
//}
@end
