//
//  YTPlaceholderTextView.m
//  GLTimeRent
//
//  Created by chips on 17/7/14.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTPlaceholderTextView.h"
#import "UILabel+YTFitSize.h"

@interface YTPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation YTPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor grayColor];
        self.placeholderLeading = 5;

        UILabel *placeholderLabel = [[UILabel alloc]init];
        self.placeholderLabel = placeholderLabel;
        [self addSubview:placeholderLabel];
        placeholderLabel.textColor = self.placeholderColor;
        placeholderLabel.font = self.font;
        UIView *containerView = self.subviews.firstObject;
        if (containerView) {
            [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.offset(0);
                make.leading.offset(self.placeholderLeading);
                make.height.equalTo(containerView);
            }];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)notifyTextDidChange {
    self.placeholderLabel.hidden = self.text.length;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self notifyTextDidChange];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    if (!placeholder.length) {
        self.placeholderLabel.hidden = YES;
    }
    _placeholder = placeholder;
    [self notifyTextDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
    _placeholderColor = placeholderColor;
    [self notifyTextDidChange];
}

- (void)setPlaceholderLeading:(CGFloat)placeholderLeading {
    [self.placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(placeholderLeading);
    }];
    [self.placeholderLabel setNeedsFocusUpdate];
    _placeholderLeading = placeholderLeading;
}

- (void)setFont:(UIFont *)font {
    self.placeholderLabel.font = font;
    [super setFont:font];
    [self notifyTextDidChange];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self notifyTextDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self notifyTextDidChange];
}

@end
