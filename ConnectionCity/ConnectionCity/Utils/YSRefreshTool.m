//
//  YSRefreshTool.m
//  dumbbell
//
//  Created by JYS on 17/3/3.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "YSRefreshTool.h"

@implementation YSRefreshTool
+ (void)endRefreshingWithView:(UIScrollView *)view {
    if (view.mj_header.isRefreshing) {
        [view.mj_header endRefreshing];
    }
    if (view.mj_footer.isRefreshing) {
        [view.mj_footer endRefreshing];
    }
}

+ (void)noticeNoMoreWithView:(UIScrollView *)view {
    [view.mj_footer endRefreshingWithNoMoreData];
}

+ (void)beginRefreshingWithView:(UIScrollView *)view {
    if (!view.mj_header.isRefreshing) {
        [view.mj_header beginRefreshing];
    }
}

+ (void)resetNoMoreDataWithView:(UIScrollView *)view {
    [view.mj_footer resetNoMoreData];
}

+ (void)addRefreshHeaderWithView:(UIScrollView *)scrollView refreshingBlock:(void(^)(void))block {
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}

+ (void)addRefreshFooterWithView:(UIScrollView *)scrollView refreshingBlock:(void(^)(void))block {
    scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

@end
