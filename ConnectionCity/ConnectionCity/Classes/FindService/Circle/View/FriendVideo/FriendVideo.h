//
//  FriendVideo.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMo.h"
@interface FriendVideo : MyCollectionView
@property (nonatomic,strong) UserMo * user;
@property (nonatomic,assign) NSInteger page;
//加载朋友圈列表
-(void)loadDataFriendList:(NSString *)cityCode flag:(NSString *)flag;
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withController:(UIViewController *)controller;
@end
@interface FriendVideoLayout : UICollectionViewFlowLayout

@end
