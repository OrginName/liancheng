//
//  ListCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_des;
@property (weak, nonatomic) IBOutlet UIImageView *iamge3;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lab_JL;
@property (weak, nonatomic) IBOutlet UILabel *lab_age;
@property (weak, nonatomic) IBOutlet UIImageView *image_sex;
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_nickName;
@property (nonatomic,strong) NSMutableArray * Arr;
@property (nonatomic,strong)Moment * mom;
@end
