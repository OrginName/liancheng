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
-(void)loadDataFriendList;//加载视频列表
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withController:(UIViewController *)controller;
@end
@interface FriendVideoLayout : UICollectionViewFlowLayout

@end
