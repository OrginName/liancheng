//
//  CreatGroupController.h
//  ConnectionCity
//
//  Created by qt on 2018/6/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
@protocol CreatGroupDelegate <NSObject>//协议
@optional
- (void)transButIndex;//协议方法
@end
typedef void (^CreatGroupBlock)(void);
@interface CreatGroupController : BaseViewController
@property (nonatomic,assign) id<CreatGroupDelegate> delegate;
@property (nonatomic,copy) CreatGroupBlock blockGroup;
@property (nonatomic,assign)int flag_str;//标志哪个地方跳出来的
@end
