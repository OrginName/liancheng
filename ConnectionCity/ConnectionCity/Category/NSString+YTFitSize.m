//
//  NSString+YTFitSize.m
//  KMTimeRent
//
//  Created by chips on 17/7/13.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "NSString+YTFitSize.h"

@implementation NSString (YTFitSize)

- (CGSize)yt_boundingSizeWithSize:(CGSize)size
                          options:(NSStringDrawingOptions)options
                       attributes:(NSDictionary<NSString *, id> *)attributes {
    CGSize fitSize = [self boundingRectWithSize:size options:options attributes:attributes context:nil].size;
    fitSize.width += 1;
    fitSize.height += 1;
    return fitSize;
}

- (CGSize)yt_boundingSizeWithSize:(CGSize)size
                       attributes:(NSDictionary<NSString *, id> *)attributes {
    return [self yt_boundingSizeWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
}

@end
