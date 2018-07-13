//
//  MYScanLineAnimation.h
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/19.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYScanLineAnimation : UIImageView

/**
 *  开始扫码线动画
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image         扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage *)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end
