//
//  ResumeController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "OurResumeMo.h"
#define NS_ENUM(...) CF_ENUM(__VA_ARGS__)
typedef NS_ENUM(NSInteger, flag) {
    flagNew =0,
    flagEdit,
    flagDelete
};
@interface ResumeController : BaseViewController
@property (nonatomic,strong)OurResumeMo * resume;
// 分页控件位置
@property (nonatomic, assign) flag flagTag;
@end
