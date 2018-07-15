//
//  UITextViewAndPlaceholder.h
//  RCloudMessage
//
//  Created by Jue on 16/7/14.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextViewAndPlaceholder : UITextView

@property(nonatomic, copy) IBInspectable NSString *myPlaceholder; //文字

@property(nonatomic, strong) IBInspectable UIColor *myPlaceholderColor; //文字颜色

@end
