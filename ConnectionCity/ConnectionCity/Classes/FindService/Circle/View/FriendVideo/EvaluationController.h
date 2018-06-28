//
//  EvaluationController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "Moment.h"
typedef void(^BtnDeleteBlock)(void);
@interface EvaluationController : BaseViewController
@property (nonatomic,strong)Moment * moment;
@property (nonatomic,copy)BtnDeleteBlock block;

@end
