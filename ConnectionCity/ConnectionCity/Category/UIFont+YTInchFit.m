//
//  UIFont+YTInchFit.m
//  KMTimeRent
//
//  Created by chips on 17/7/13.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "UIFont+YTInchFit.h"
#import "YTSystemUtil.h"

@implementation UIFont (YTInchFit)

+ (UIFont *)yt_systemFontOfSize:(CGFloat)fontSize {
    CGFloat fitFontSize = fontSize;
    switch ([YTSystemUtil getIphoneInch]) {
        case YTSystemUtilScreenInch4_0:
            fitFontSize *= 0.9;
            break;
        case YTSystemUtilScreenInch4_7:
            break;
        case YTSystemUtilScreenInch5_5:
            break;
    }
    return [UIFont systemFontOfSize:fitFontSize];
}

@end
