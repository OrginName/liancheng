//
//  UIBarButtonItem+Extension.m
//  dumbbell
//
//  Created by JYS on 16/3/10.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image title:(NSString *)title
{
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 36, 36);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];

    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}


@end
