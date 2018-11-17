//
//  VideoLayout.m
//  ConnectionCity
//
//  Created by qt on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "VideoLayout.h"

@implementation VideoLayout
-(void)prepareLayout{
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width-5)/ 2;
    self.itemSize = CGSizeMake(itemW, (self.collectionView.height-5)/2);
    //设置最小间距
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    self.sectionInset = UIEdgeInsetsMake(0,0, 0, 0);
}
@end
