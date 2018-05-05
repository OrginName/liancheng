//
//  YSRefreshTool.h
//  dumbbell
//
//  Created by JYS on 17/3/3.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSRefreshTool : NSObject

+ (void)addRefreshHeaderWithView:(UIScrollView *)scrollView refreshingBlock:(void(^)())block;

+ (void)addRefreshFooterWithView:(UIScrollView *)scrollView refreshingBlock:(void(^)())block;

+ (void)beginRefreshingWithView:(UIScrollView *)view;

+ (void)endRefreshingWithView:(UIScrollView *)view;

+ (void)noticeNoMoreWithView:(UIScrollView *)view;

+ (void)resetNoMoreDataWithView:(UIScrollView *)view;

@end
