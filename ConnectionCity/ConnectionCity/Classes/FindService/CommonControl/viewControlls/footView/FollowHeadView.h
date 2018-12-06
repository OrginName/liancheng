//
//  FollowHeadView.h
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^indexClick)(NSIndexPath * index);
@interface FollowHeadView : UITableViewHeaderFooterView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * coll_Bottom;
@property (nonatomic,strong)UIViewController * controller;
@property (nonatomic,strong)UIView * view_line;
@property (nonatomic,strong)NSMutableArray * arr_receive;
@property (nonatomic,copy)indexClick clickBlock;
@end

@interface FollowLayout : UICollectionViewFlowLayout

@end
