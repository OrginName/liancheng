//
//  YTSideMenuModel.h
//  JLTimeRent
//
//  Created by chips on 17/6/26.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTSideMenuModel : NSObject

/** 图标字符串 */
@property (nonatomic, copy) NSString *mIcon;
/** 标题字符串 */
@property (nonatomic, copy) NSString *mTitle;
/** 需跳转的控制器类名 */
@property (nonatomic, copy) NSString *mClass;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end
