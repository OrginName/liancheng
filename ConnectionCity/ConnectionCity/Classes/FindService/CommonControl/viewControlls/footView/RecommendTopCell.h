//
//  RecommendTopCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTopCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView * coll_Bottom;
@end
@interface ReLayout : UICollectionViewFlowLayout

@end
