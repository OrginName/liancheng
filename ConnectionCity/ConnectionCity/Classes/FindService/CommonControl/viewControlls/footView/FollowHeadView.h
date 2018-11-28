//
//  FollowHeadView.h
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowHeadView : UITableViewHeaderFooterView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * coll_Bottom;
@property (nonatomic,strong)UIView * view_line;

@end
@interface FollowLayout : UICollectionViewFlowLayout

@end
