//
//  UILabel+YTFitSize.h
//  KMTimeRent
//
//  Created by chips on 17/7/13.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YTFitSize)

- (CGSize)yt_boundingSizeWithSize:(CGSize)size
                          options:(NSStringDrawingOptions)options
                       attributes:(NSDictionary<NSString *, id> *)attributes;

- (CGSize)yt_boundingSizeWithSize:(CGSize)size;

- (CGSize)yt_boundingSize;

- (void)yt_updateSizeConstraints;

@end
