//
//  YCProjectScanningController.h
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/4.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import "BaseViewController.h"

@interface YCProjectScanningController : BaseViewController

@property (nonatomic, copy) void (^completionHandler) (NSString *result);

@end
