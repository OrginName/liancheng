
//
//  CustomPage.m
//  testBar
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 qt. All rights reserved.
//

#import "CustomPage.h"
#import "CustomTabr.h"
@interface CustomPage()<CustomtabDelegate>
{
    NSArray * titlesArray;
    NSArray * viewsArray;
    NSArray * SelectArr;
    NSArray * deSelectArr;
    NSInteger currentIndex;
}
@property (nonatomic,strong) CustomTabr * customBar;
@end
@implementation CustomPage
#pragma mark - init
- (instancetype)initSegmentWithFrame:(CGRect)frame
                         titlesArray:(NSArray *)titles
                       withSelectArr:(NSArray *)selectArr withDeSlectArr:(NSArray *)DeSlectArr vcOrviews:(NSArray *)views {
    if (self = [super initWithFrame:frame]) {
        titlesArray = [titles copy];
        viewsArray = [views copy];
        SelectArr = [selectArr copy];
        deSelectArr = [DeSlectArr copy];
        [self defaultSet];
    }
    return self;
}
#pragma mark - 默认
- (void)defaultSet {
    currentIndex = 0;
    _showIndex = 0;
    _selectColor = [UIColor orangeColor];
    _deselectColor = [UIColor lightGrayColor];
    _fontSize = 13;
    _headHeight = 50;
    _headColor = [UIColor whiteColor];
}
#pragma mark - layoutsubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    _customBar.tabBarColor = _headColor;
    _customBar.titleSelectColor = _selectColor;
    _customBar.titleDeSelctColor = _deselectColor;
    currentIndex = _showIndex;
    _customBar.titleFont = _fontSize;
    [self addSubview:self.customBar];
    for (int i=0; i<viewsArray.count; i++) {
        [self addVC:viewsArray[i] atIndex:0];
    }
}
#pragma mark - addvc
- (void)addVC:(UIViewController *)vc atIndex:(NSInteger)index {
    NSLog(@"add - %@",@(index));
    
    vc.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.viewController addChildViewController:vc];
//    [self addSubview:vc.view];
    
    
}
-(CustomTabr *)customBar{
    if (!_customBar) {
        _customBar = [[CustomTabr alloc] initWithFrame:CGRectMake(0, self.frame.size.height-_headHeight, self.frame.size.width, _headHeight) withSelectArr:SelectArr withDeSlectArr:deSelectArr withTitleArr:titlesArray];
        _customBar.delegate = self;
    }
    
    return _customBar;
}
- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}
#pragma mark - SegmentHeadViewDelegate
- (void)didSelectedIndex:(NSInteger)index {
    UIViewController * con = viewsArray[index];
    [self addSubview:con.view];
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:index];
    }
    
}
@end
