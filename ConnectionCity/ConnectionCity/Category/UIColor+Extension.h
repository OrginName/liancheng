//
//  UIColor+Extension.h
//  dumbbell
//
//  Created by JYS on 16/3/14.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *)colorWithHex:(unsigned long)col;
+ (UIColor *)hexColorWithString:(NSString *)string;
+ (UIColor *)hexColorWithString:(NSString *)string alpha:(float) alpha;
@end
