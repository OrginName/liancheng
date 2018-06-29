//
//  ServiceListCell.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceListMo.h"
@interface ServiceListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_des;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (nonatomic,strong)ServiceListMo * list;
@end
