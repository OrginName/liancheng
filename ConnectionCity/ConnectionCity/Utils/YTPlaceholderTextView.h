//
//  YTPlaceholderTextView.h
//  GLTimeRent
//
//  Created by chips on 17/7/14.
//  Copyright © 2017年 YOU-TURN TECHNOLOGY CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 带placeholder的TextView */
@interface YTPlaceholderTextView : UITextView

/** placeholder */
@property (nonatomic, copy) NSString *placeholder;
/** placeholder字体颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** placeholder距左边缘距离 */
@property (nonatomic, assign) CGFloat placeholderLeading;

@end
