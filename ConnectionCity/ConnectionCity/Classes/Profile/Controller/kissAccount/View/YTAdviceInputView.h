//
//  YTAdviceInputView.h
//  JLTimeRent
//
//  Created by chips on 17/6/23.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTPlaceholderTextView;

/** 意见输入View */
@interface YTAdviceInputView : UIView

/** 意见输入TextView */
@property (nonatomic, strong) YTPlaceholderTextView *textView;
/** 输入的意见文本 */
@property (nonatomic, copy, readonly) NSString *text;
/** 意见字数限制 */
@property (nonatomic, assign) NSUInteger count;

@end
