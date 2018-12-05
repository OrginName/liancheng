//
//  RecommendController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/11/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendController : BaseViewController

@end
@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView * image1;
@property (nonatomic,strong) UIImageView * image2;

@end
NS_ASSUME_NONNULL_END
