//
//  NKColorSwitch.h
//
//  Created by Naohiko on 7/30/13.
//  Copyright (c) 2013 Naohiko Kosaka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kNKColorSwitchShapeOval,
    kNKColorSwitchShapeRectangle,
    kNKColorSwitchShapeRectangleNoCorner
} NKColorSwitchShape;

@interface NKColorSwitch : UIControl <UIGestureRecognizerDelegate>

/* A Boolean value that determines the off/on state of the switch. */
@property (nonatomic, getter = isOn) IBInspectable BOOL on;

/* A value that determines the shape of the switch control */
@property (nonatomic, assign) IBInspectable NKColorSwitchShape shape;

/* The color used to tint the appearance of the switch when it is turned on. */
@property (nonatomic, strong) IBInspectable UIColor *onTintColor;

/* The color used to tint the appearance when the switch is disabled. */
@property (nonatomic, strong) IBInspectable UIColor *tintColor;

/* The color used to tint the appearance of the thumb. */
@property (nonatomic, strong) IBInspectable UIColor *thumbTintColor;

/* Thumb drop shadow on/off */
@property (nonatomic, assign) IBInspectable BOOL shadow;

/* The border color used to tint the appearance when the switch is disabled. */
@property (nonatomic, strong) IBInspectable UIColor *tintBorderColor;

/* The border color used to tint the appearance of the switch when it is turned on. */
@property (nonatomic, strong) IBInspectable UIColor *onTintBorderColor;

@property (nonatomic, strong) IBInspectable UILabel *onBackLabel;//打开时候的文字
@property (nonatomic, strong) IBInspectable UILabel *offBackLabel;//关闭时候的文字

@end
