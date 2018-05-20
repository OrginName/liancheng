//
//  CustomPage.h
//  testBar
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomPageDelegate <NSObject>
///点击
- (void)selectedIndex:(NSInteger)index;

@end

@interface CustomPage : UIView
///选中颜色，默认 - blackColor
@property (nonatomic, strong) UIColor *selectColor;
///未选中颜色，默认 - lightGrayColor
@property (nonatomic, strong) UIColor *deselectColor;
///字体大小，默认 - 13
@property (nonatomic, assign) CGFloat fontSize;
///默认显示开始的位置，默认 - 1
@property (nonatomic, assign) NSInteger showIndex;
///顶部背景颜色，默认 - groupTableViewBackgroundColor
@property (nonatomic, strong) UIColor *headColor;
///顶部高度，默认 - 50
@property (nonatomic, assign) CGFloat headHeight;
///缓存页面数目，默认 - all
@property (nonatomic, assign) NSInteger countLimit;

///delegate
@property (nonatomic, weak) id<CustomPageDelegate> delegate;

- (instancetype)initSegmentWithFrame:(CGRect)frame
                         titlesArray:(NSArray *)titles
                       withSelectArr:(NSArray *)selectArr withDeSlectArr:(NSArray *)DeSlectArr vcOrviews:(NSArray *)views;

@end
