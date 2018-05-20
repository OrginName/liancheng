//
//  CustomTabr.h
//  testBar
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomtabDelegate <NSObject>

/**
 *  selected
 *
 *  @param index index
 */
- (void)didSelectedIndex:(NSInteger)index;

@end
@interface CustomTabr : UIView
@property (nonatomic,strong)UIColor * tabBarColor;//当前tabbar颜色
@property (nonatomic,strong) UIColor * titleSelectColor;//标题选中颜色
@property (nonatomic,strong) UIColor * titleDeSelctColor;//标题未选中颜色
@property (nonatomic,assign) CGFloat titleFont;//标题尺寸
@property (nonatomic, weak) id<CustomtabDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withSelectArr:(NSArray *)selectArr withDeSlectArr:(NSArray *)DeSlectArr withTitleArr:(NSArray *)TitleArr;
@end
