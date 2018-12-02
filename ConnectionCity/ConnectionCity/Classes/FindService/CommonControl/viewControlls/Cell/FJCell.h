//
//  FJCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceMo.h"
@interface FJCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UIImageView *image_sex;
@property (weak, nonatomic) IBOutlet UILabel *lab_JL;
@property (nonatomic,strong) NearByMo * mo;
@end
