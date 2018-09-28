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
    ENUM_TypeCard,//身份
    ENUM_TypeTrval//陪游 邀约
} Receive_Type;
@interface ShowResumeController : BaseViewController
@property (nonatomic,strong) NSString * flag;//代表哪个界面进去的
//1:服务详情  2：简历详情 
@property(nonatomic,assign) NSInteger  Receive_Type;//接受类型
@property (nonatomic,strong) NSMutableArray * data_Count;
@property (nonatomic,assign) NSInteger zIndex;
@property (nonatomic,strong) NSString * str;//判断传进来的是哪个
@end
