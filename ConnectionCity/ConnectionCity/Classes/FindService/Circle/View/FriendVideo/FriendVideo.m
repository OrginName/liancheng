//
//  FriendVideo.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendVideo.h"
#import "FriendVideoCell.h"
#import "MommentPlayerController.h"
@interface FriendVideo()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIViewController * controller;
@end
@implementation FriendVideo
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withController:(UIViewController *)controller{
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        self.controller = controller;
        self.backgroundColor = [UIColor clearColor];
        self.collectionViewLayout = [[FriendVideoLayout alloc] init];
        [self registerNib:[UINib nibWithNibName:@"FriendVideoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VideoCell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
//-(instancetype)initWithFrame:(CGRect)frame{
//    if(self=[super initWithFrame:frame]){
//
//
//    }
//    return self;
//}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendVideoCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.controller.navigationController pushViewController:[MommentPlayerController new] animated:YES];
}
@end
@implementation FriendVideoLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width-5)/ 2;
    self.itemSize = CGSizeMake(itemW, (self.collectionView.height-5)/2);
    //设置最小间距
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    self.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);
}
@end