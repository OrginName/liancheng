//
//  TopCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceMo.h"
@interface TopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (nonatomic,strong)HotServiceMo * mo;
@end
