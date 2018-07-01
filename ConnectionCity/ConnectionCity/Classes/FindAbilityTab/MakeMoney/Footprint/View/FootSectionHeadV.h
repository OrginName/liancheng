//
//  FootSectionHeadV.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"

@interface FootSectionHeadV : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *headerImgV;
@property (nonatomic, strong) UILabel *bidderLab;
@property (nonatomic, strong) UILabel *winNumbersLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) FirstControllerMo *model;

@end
