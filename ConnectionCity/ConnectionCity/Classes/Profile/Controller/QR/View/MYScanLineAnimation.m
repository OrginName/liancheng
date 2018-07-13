//
//  MYScanLineAnimation.m
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/19.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//


#import "MYScanLineAnimation.h"

#define LINE_HEIGHT 3.0f

@interface MYScanLineAnimation(){
    int num;
    BOOL down;
    NSTimer * timer;
    BOOL isAnimationing;
}
@property (nonatomic,assign) CGRect animationRect;
@end


@implementation MYScanLineAnimation

- (void)stepAnimation
{
    if (!isAnimationing) {
        return;
    }
    
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 2*LINE_HEIGHT, width, LINE_HEIGHT);
    
    self.alpha = 0.0;
    
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
        
    } completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 2*LINE_HEIGHT, width, LINE_HEIGHT);
        
    } completion:^(BOOL finished) {
         self.hidden = YES;
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}



- (void)startAnimatingWithRect:(CGRect)animationRect InView:(UIView *)parentView Image:(UIImage *)image
{
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    self.animationRect = animationRect;
    down = YES;
    num = 0;
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    self.frame = CGRectMake(leftx, centery+2*num, width, LINE_HEIGHT);
    self.image = image;
    [parentView addSubview:self];
    [self startAnimating_UIViewAnimation];
}

- (void)startAnimating_UIViewAnimation{
    [self stepAnimation];
}

- (void)startAnimating_NSTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
}

-(void)scanLineAnimation{
    CGFloat centery = CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect)/2;
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    if (down){
        num++;
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        if (centery+2*num > (CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect) - 5 ) ){
            down = NO;
        }
    }else {
        num --;
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        if (centery+2*num < (CGRectGetMinY(_animationRect) + 5 ) )
        {
            down = YES;
        }
    }
}


- (void)stopAnimating {
    if (isAnimationing) {
        isAnimationing = NO;
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


- (void)dealloc {
    [self stopAnimating];
}


@end
