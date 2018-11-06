//
//  NewsListCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLMo.h"
@interface NewsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_context;
@property (weak, nonatomic) IBOutlet UIImageView *iamge_yl;
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (nonatomic,strong) YLMo * ylMo;
@end
