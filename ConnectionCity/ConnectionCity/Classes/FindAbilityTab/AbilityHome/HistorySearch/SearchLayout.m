//
//  SearchLayout.m
//  ConnectionCity
//
//  Created by qt on 2018/5/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SearchLayout.h"

@implementation SearchLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 60)/ 3;
    self.itemSize = CGSizeMake(itemW, 40);
    
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(20, 10, 0, 10);
}
@end
