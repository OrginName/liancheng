//
//  MyCollectionView.m
//  ConnectionCity
//
//  Created by qt on 2018/7/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyCollectionView.h"

@implementation MyCollectionView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self Mydelegate];
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self Mydelegate];
    };
    return self;
}
-(void)Mydelegate{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
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