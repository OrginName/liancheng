//
//  UIView+YSCategory.h
//  dumbbell
//
//  Created by JYS on 17/3/3.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSInteger{
    
    ShadowPathLeft,
    
    ShadowPathRight,
    
    ShadowPathTop,
    
    ShadowPathBottom,
    
    ShadowPathNoTop,
    
    ShadowPathAllSide
    
} ShadowPathSide;
@interface UIView (YSCategory)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 
 */

-(void)SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(ShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;
@end
