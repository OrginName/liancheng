//
//  SelectWeek.h
//  ConnectionCity
//
//  Created by qt on 2018/8/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WeekBlock)(NSString * weekStr,NSString * weekID);
@interface SelectWeek : UIView
@property (nonatomic,copy)WeekBlock weekBlock;
@end
