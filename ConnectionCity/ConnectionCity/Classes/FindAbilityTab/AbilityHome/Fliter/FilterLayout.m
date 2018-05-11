//
//  FilterLayout.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FilterLayout.h"

@implementation FilterLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 40)/ 3;
    self.itemSize = CGSizeMake(itemW, 50);
    
    //设置最小间距
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    [self setHeaderReferenceSize:CGSizeMake(self.collectionView.frame.size.width,50)];
//    [self setFooterReferenceSize:CGSizeMake(self.collectionView.frame.size.width,100)];
}
@end
