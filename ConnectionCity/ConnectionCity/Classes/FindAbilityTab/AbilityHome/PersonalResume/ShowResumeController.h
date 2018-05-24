//
//  ShowResumeController.h
//  ConnectionCity
//  简历展示界面
//  Created by qt on 2018/5/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
//定义枚举类型
typedef enum {
    ENUM_TypeResume=0,//简历
    ENUM_TypeTreasure,//宝物
    ENUM_TypeCard//身份
} Receive_Type;
@interface ShowResumeController : BaseViewController
@property(nonatomic,assign) NSInteger  Receive_Type;//接受类型
@end
