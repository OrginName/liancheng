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
typedef void(^ResumeBlock1)(ResumeMo * Mo);
typedef void(^ResumeBlock2)(void);
@interface GuardEduController : BaseViewController
@property (nonatomic, copy) ResumeBlock block;
@property (nonatomic, copy) ResumeBlock1 block1;
@property (nonatomic, copy) ResumeBlock2 block2;

@property (nonatomic,strong) NSArray * eduArr;//学历Dic
@property (nonatomic,strong) NSString * resumeID;//简历ID
@property (nonatomic,strong) ResumeMo * mo;//接收到的resume
@end
