//
//  MommentPlayerController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "Moment.h"
typedef void(^MommentDeleteBlock)(void);

@interface MommentPlayerController : BaseViewController
@property (nonatomic,copy) MommentDeleteBlock block;
@property (nonatomic,strong)Moment * moment;
@end
