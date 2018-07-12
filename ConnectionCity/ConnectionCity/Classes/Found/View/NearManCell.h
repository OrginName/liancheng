//
//  NearManCell.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionMo.h"
@interface NearManCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UIImageView *image_Sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Distance;
@property (nonatomic,strong)ConnectionMo * mo;
@end
