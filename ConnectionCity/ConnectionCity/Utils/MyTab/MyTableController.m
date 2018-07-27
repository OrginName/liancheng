//
//  MyTableController.m
//  ConnectionCity
//
//  Created by qt on 2018/7/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyTableController.h"
@interface MyTableController ()
@end
@implementation MyTableController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}
@end
