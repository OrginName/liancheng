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
@property (nonatomic,strong)UIView * view_Bottom;
@property (nonatomic,strong)NSString * flagStr;//标识加载的cell类型
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFlag:(NSString *)flag;
@end
@interface ReLayout : UICollectionViewFlowLayout

@end
@interface FJLayout : UICollectionViewFlowLayout

@end
