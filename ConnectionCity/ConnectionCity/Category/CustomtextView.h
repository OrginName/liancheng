//
//  CustomtextView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomtextView : UITextView
/** 占位文字 */
@property (nonatomic, copy)IBInspectable  NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong)IBInspectable  UIColor *placeholderColor;
@end
