//
//  UIBarButtonItem+Extension.h
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image title:(NSString *)title;

@end
