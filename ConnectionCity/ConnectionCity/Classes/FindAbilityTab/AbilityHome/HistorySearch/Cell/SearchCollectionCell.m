//
//  SearchCollectionCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SearchCollectionCell.h"
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
@interface SearchCollectionCell ()
@property (nonatomic, strong) UILabel *label;
@end
@implementation SearchCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = YSColor(100, 100, 100);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label = label;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBAColor(155, 155, 165, 0.5).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

@end
