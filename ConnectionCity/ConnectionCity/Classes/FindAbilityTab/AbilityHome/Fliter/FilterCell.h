//
//  FilterCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UICollectionViewCell
@property (nonatomic, strong) UILabel * lab_title;
- (void)configCellWithData:(NSDictionary *)dic;
@end
@interface FilterCellFour : UICollectionViewCell
- (void)configCellWithData:(NSDictionary *)dic;
@end
