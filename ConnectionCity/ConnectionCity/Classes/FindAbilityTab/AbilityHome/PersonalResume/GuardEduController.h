//
//  GuardEduController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeMo.h"
typedef void(^ResumeBlock)(ResumeMo * Mo);
@interface GuardEduController : BaseViewController
@property (nonatomic, copy) ResumeBlock block;

@end
