//
//  UIFont+YTInchFit.h
//  KMTimeRent
//
//  Created by chips on 17/7/13.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 字体根据屏幕尺寸适应 */
@interface UIFont (YTInchFit)

+ (UIFont *)yt_systemFontOfSize:(CGFloat)fontSize;

@end
