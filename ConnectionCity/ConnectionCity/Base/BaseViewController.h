//
//  BaseViewController.h
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,assign) BOOL flag_back;
/** 获取文件路径 */
- (NSString *)getFilePathWithName:(NSString *)name;
//类名转换类
-(UIViewController *)rotateClass:(NSString *)name;
@end
