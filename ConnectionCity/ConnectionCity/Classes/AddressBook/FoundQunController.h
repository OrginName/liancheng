//
//  BulidTeamController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface FoundQunController : BaseViewController

@end

//新建自定义类 扩充tagId属性 记录区号
@interface ZYButton : UIButton

@property (assign, nonatomic) NSInteger tagId;

@end
