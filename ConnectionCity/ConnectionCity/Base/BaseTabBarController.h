//
//  BaseTabBarController.h
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController
@property(nonatomic, assign) NSUInteger selectedTabBarIndex;
+ (BaseTabBarController *)shareInstance;
@end
