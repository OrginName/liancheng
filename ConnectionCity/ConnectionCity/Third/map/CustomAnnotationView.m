//
//  CustomAnnotationView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
 
#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   150.0
#define kCalloutHeight  40.0
@interface CustomAnnotationView ()
@property (nonatomic, strong) UIImageView *portraitImageView;
@end

@implementation CustomAnnotationView

@synthesize portraitImageView   = _portraitImageView;

#pragma mark - Override

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, kCalloutWidth, kCalloutHeight)];
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor blackColor];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"5分钟后服务"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor hexColorWithString:@"f49930"] range:NSMakeRange(0,4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor hexColorWithString:@"282828"] range:NSMakeRange(4,2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 6)];
            name.attributedText = str;
            name.textAlignment = NSTextAlignmentCenter;
            [self.calloutView addSubview:name];
        }
         [self addSubview:self.calloutView];
    }else{
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    return self;
}
@end
