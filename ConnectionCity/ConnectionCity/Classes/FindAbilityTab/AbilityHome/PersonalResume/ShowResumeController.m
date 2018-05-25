//
//  ShowResumeController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowResumeController.h"
#import "ShowResumeTab.h"
#import "ShowCardTab.h"
#import "ShowTreaueTab.h"
#define identifier @"ScrollCell"
#define TabHeight kScreenHeight-185
@interface ShowResumeController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, assign)Boolean isFullScreen;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)ShowResumeTab * showTab;
@property (nonatomic, strong)ShowCardTab * showCardTab;
@property (nonatomic, strong)ShowTreaueTab * showTreaueTab;
@property (nonatomic, strong)UIButton * btn_Like;
@property (nonatomic, strong)UIButton * Save_Like;
@end

@implementation ShowResumeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark --- 分享按钮点击-----
-(void)Share{
    [YTAlertUtil showTempInfo:@"分享"];
}
-(void)setUI{
     self.imageArray = [NSMutableArray arrayWithArray:@[@"001.jpg",@"002.jpg",@"003.jpg"]];
    [self.view addSubview:self.collectionView];
    if(self.Receive_Type == ENUM_TypeCard){
        self.title = @"互换身份";
        [self.view addSubview:self.btn_Like];
    }else if (self.Receive_Type == ENUM_TypeResume){
       self.title = @"个人简历";
    }else if (self.Receive_Type == ENUM_TypeTreasure){
        self.title = @"互换宝物";
        [self.view addSubview:self.btn_Like];
        [self.view addSubview:self.Save_Like];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Share) image:@"share" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _currentIndex = 0;
}

#pragma mark --各种点击事件---
//导航栏完成按钮点击
-(void)complete{
    
}
//点赞按钮点击
-(void)likeClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
//收藏按钮点击
-(void)SaveClick:(UIButton *)sender{
    sender.selected = !sender.selected;
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
    }else if(self.Receive_Type == ENUM_TypeCard){
        self.showCardTab = [[ShowCardTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        [cell.contentView addSubview:self.showCardTab];
    }else {
        self.showTreaueTab = [[ShowTreaueTab alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, TabHeight)];
        [cell.contentView addSubview:self.showTreaueTab];
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
#warning 收藏按钮选中和未选中图片记得更换
-(UIButton *)Save_Like{
    if (!_Save_Like) {
        _Save_Like = [[UIButton alloc] initWithFrame:CGRectMake(_collectionView.width-30, 70, 30, 40)];
        _Save_Like.backgroundColor = [UIColor whiteColor];
        _Save_Like.layer.cornerRadius = 5;
        [_Save_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
        [_Save_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
        _Save_Like.titleLabel.font = [UIFont systemFontOfSize:13];
        [_Save_Like setTitle:@"12" forState:UIControlStateNormal];
        [_Save_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
        [_Save_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
        [_Save_Like addTarget:self action:@selector(SaveClick:) forControlEvents:UIControlEventTouchUpInside];
        [_Save_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    return _Save_Like;
}
-(UIButton *)btn_Like{
    if (!_btn_Like) {
        _btn_Like = [[UIButton alloc] initWithFrame:CGRectMake(_collectionView.width-30, 20, 30, 40)];
        _btn_Like.backgroundColor = [UIColor whiteColor];
        _btn_Like.layer.cornerRadius = 5;
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise"] forState:UIControlStateNormal];
        [_btn_Like setImage:[UIImage imageNamed:@"s-praise1"] forState:UIControlStateSelected];
        _btn_Like.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn_Like setTitle:@"12" forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(181, 181, 181) forState:UIControlStateNormal];
        [_btn_Like setTitleColor:YSColor(251, 159, 14) forState:UIControlStateSelected];
        [_btn_Like addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_Like layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:2];
    }
    return _btn_Like;
}

- (IBAction)UPDownClick:(UIButton *)sender {
//    [self layoutIfNeeded];
    if (sender.tag==1) {
        _currentIndex--;
        if (_currentIndex<=0) {
            _currentIndex=0;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        _currentIndex++;
        if (_currentIndex>self.imageArray.count-1) {
            _currentIndex=self.imageArray.count-1;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
@end
