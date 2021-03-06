//
//  ListCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "GZMo.h"
@class ListCell;
typedef void (^BtnClickBlock)(ListCell * cell);
typedef void (^btnHeadClick)(ListCell * cell);
typedef void (^labClickBlock)(ListCell * cell);
@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (weak, nonatomic) IBOutlet UIView *view_ageSex;
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
@property (nonatomic,copy)BtnClickBlock block;
@property (nonatomic,copy)btnHeadClick headBlcok;
@property (nonatomic,strong)CircleListMo * mo;
@property (nonatomic,copy)labClickBlock labBlock;
@end
