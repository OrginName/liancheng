//
//  FollwCollectionViewCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZMo.h"
@interface FollwCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UIImageView *image_Bottom;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (nonatomic,strong)GZMo * mo;
@end
