//
//  CollectionCell.h
//  ConnectionCity
//
//  Created by qt on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
@class CollectionCell;
@protocol CollectionCellDelegate <NSObject>
@optional
-(void)didCancleClick:(CollectionCell *)cell;
@optional
-(void)didPlayMyVideo:(CollectionCell *)cell;
@optional
//展开收起
- (void)didSelectFullText:(CollectionCell *)cell;
@end
@interface CollectionCell : UITableViewCell
@property (nonatomic,strong)UIImageView * imagePlay;
@property (nonatomic,strong)Moment * receive_Mo;
@property (nonatomic, assign) id<CollectionCellDelegate> delegate;
@end
