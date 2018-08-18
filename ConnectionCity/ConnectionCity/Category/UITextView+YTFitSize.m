//
//  UITextView+YTFitSize.m
//  KMTimeRent
//
//  Created by chips on 17/7/13.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "UITextView+YTFitSize.h"
#import "NSString+YTFitSize.h"

@implementation UITextView (YTFitSize)

- (CGSize)yt_boundingSizeWithSize:(CGSize)size
                          options:(NSStringDrawingOptions)options
                       attributes:(NSDictionary<NSString *, id> *)attributes {
    CGSize fitSize = [self.text yt_boundingSizeWithSize:size options:options attributes:attributes];
    fitSize.width += 1;
    fitSize.height += 1;
    return fitSize;
}

- (CGSize)yt_boundingSizeWithSize:(CGSize)size {
    return [self.text yt_boundingSizeWithSize:size attributes:@{NSFontAttributeName: self.font}];
}

- (CGSize)yt_boundingSize {
    return [self yt_boundingSizeWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

- (void)yt_updateSizeConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self yt_boundingSize]);
    }];
    [self setNeedsUpdateConstraints];
}

@end
