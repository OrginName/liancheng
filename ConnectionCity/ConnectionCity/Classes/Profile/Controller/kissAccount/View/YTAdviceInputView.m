//
//  YTAdviceInputView.m
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import "YTAdviceInputView.h"
#import "YTPlaceholderTextView.h"
#import "YTAlertUtil.h"

@interface YTAdviceInputView () <UITextViewDelegate>

/** 字数限制Label */
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation YTAdviceInputView

- (void)setCount:(NSUInteger)count {
    [self p_setupCountLabelWithCount:count currentCount:0];
    _count = count;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
        self.backgroundColor = [UIColor whiteColor];
        self.count = 100;
    }
    return self;
}

- (void)addSubviews {
    self.textView = [[YTPlaceholderTextView alloc]init];
    [self addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.editable = YES;
    self.textView.selectable = YES;
    self.textView.selectedRange = NSMakeRange(0, 0);

    self.countLabel = [[UILabel alloc]init];
    [self addSubview:self.countLabel];
    self.countLabel.textColor = self.textView.placeholderColor;
    self.countLabel.font = [UIFont systemFontOfSize:13];
    self.countLabel.textAlignment = NSTextAlignmentRight;

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.textView).offset(-AppViewLayoutMargin);
        make.bottom.equalTo(self.textView);
        make.width.equalTo(@66);
        make.height.equalTo(@(AppViewSingleLineLabelHeight));
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView != self.textView) {
        return;
    }
    NSUInteger currentLen = textView.text.length;
    if (currentLen > self.count) {
        NSUInteger restLen = currentLen-self.count;
        textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(currentLen-restLen, restLen) withString:@""];
        [YTAlertUtil showTempInfo:@"超出字数限制!"];
    }
    [self p_setupCountLabelWithCount:self.count currentCount:textView.text.length];
    _text = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private method
- (void)p_setupCountLabelWithCount:(NSUInteger)count currentCount:(NSUInteger)currentCount {
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)currentCount, (unsigned long)count];
}

@end
