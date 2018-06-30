//
//  BiddInfoHeadView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/5/26.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"
#import "privateUserInfoModel.h"

@interface BiddInfoHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *industryLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *companeyAndAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) FirstControllerMo *model;

@end
