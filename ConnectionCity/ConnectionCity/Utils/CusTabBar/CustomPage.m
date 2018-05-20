
//
//  CustomPage.m
//  testBar
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 qt. All rights reserved.
//

#import "CustomPage.h"
#import "CustomTabr.h"
@interface CustomPage()<CustomtabDelegate,NSCacheDelegate,UIScrollViewDelegate>
{
    NSArray * titlesArray;
    NSArray * viewsArray;
    NSArray * SelectArr;
    NSArray * deSelectArr;
    NSInteger currentIndex;
    NSMutableArray * navArray;
}
@property (nonatomic, strong) UIScrollView *viewsScroll;

@property (nonatomic, strong) NSCache *viewsCache;//存储页面(使用计数功能)
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
        navArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backWhere:) name:@"backWhere" object:nil];
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
    _countLimit = titlesArray.count;
}
#pragma mark - viewsCache
- (NSCache *)viewsCache {
    if (!_viewsCache) {
        _viewsCache = [[NSCache alloc] init];
        _viewsCache.countLimit = _countLimit;
        _viewsCache.delegate = self;
    }
    return _viewsCache;
}
#pragma mark - layoutsubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    _customBar.tabBarColor = _headColor;
    _customBar.titleSelectColor = _selectColor;
    _customBar.titleDeSelctColor = _deselectColor;
    currentIndex = _showIndex;
    _customBar.titleFont = _fontSize;
    _countLimit = MAX(1, MIN(_countLimit, titlesArray.count));
    [self addSubview:self.customBar];
    [self createViewsScroll];
    [self defaultViewCache];
}
#pragma mark - create_scroll
- (void)createViewsScroll {
    _viewsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - _headHeight)];
    _viewsScroll.userInteractionEnabled = NO;
    _viewsScroll.showsVerticalScrollIndicator = NO;
    _viewsScroll.showsHorizontalScrollIndicator = NO;
    _viewsScroll.bounces = NO;
    _viewsScroll.delegate = self;
    _viewsScroll.pagingEnabled = YES;
//    [_viewsScroll setContentOffset:CGPointMake(_showIndex * self.frame.size.width, 0)];
    [_viewsScroll setContentSize:CGSizeMake(viewsArray.count *_viewsScroll.frame.size.width, _viewsScroll.frame.size.height)];
    [self addSubview:_viewsScroll];
}
- (void)defaultViewCache {
    
        NSInteger startIndex;
        if (viewsArray.count-_showIndex > _countLimit) {
            startIndex = _showIndex;
        } else {
            startIndex = _showIndex - (_countLimit - (viewsArray.count-_showIndex));
        }
        for (NSInteger i = startIndex; i < startIndex + _countLimit; i ++) {
            [self addViewCacheIndex:i];
        }
    
    
}
#pragma mark - createByVC
- (void)addViewCacheIndex:(NSInteger)index {
    id object = viewsArray[index];
    if ([object isKindOfClass:[NSString class]]) {
        Class class = NSClassFromString(object);
        if ([class isSubclassOfClass:[UIViewController class]]) {//vc
            UIViewController *vc = [class new];
            [self addVC:vc atIndex:index];
        } else if ([class isSubclassOfClass:[UIView class]]){//view
            UIView *view = [class new];
            [self addView:view atIndex:index];
        } else {
            NSLog(@"please enter the correct name of class!");
        }
    } else {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self addVC:object atIndex:index];
        } else if ([object isKindOfClass:[UIView class]]) {
            [self addView:object atIndex:index];
        } else {
            NSLog(@"this class was not found!");
        }
    }
    
}

#pragma mark - addvc
- (void)addVC:(UIViewController *)vc atIndex:(NSInteger)index {
    NSLog(@"add - %@",@(index));
    [self.viewsCache setObject:vc forKey:@(index)];
    
    vc.view.frame = CGRectMake(index*_viewsScroll.frame.size.width, 0, _viewsScroll.frame.size.width, _viewsScroll.frame.size.height);
    [self.viewController addChildViewController:vc];
    [_viewsScroll addSubview:vc.view];
    
    
}

#pragma mark - addview
- (void)addView:(UIView *)view atIndex:(NSInteger)index {
    [self.viewsCache setObject:view forKey:@(index)];
    
    view.frame = CGRectMake(index*_viewsScroll.frame.size.width, 0, _viewsScroll.frame.size.width, _viewsScroll.frame.size.height);
    [_viewsScroll addSubview:view];
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
     [_viewsScroll setContentOffset:CGPointMake((index+1)*self.frame.size.width, 0) animated:NO];
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:index];
    }
}
-(void)backWhere:(NSNotification *)noti{
    [_viewsScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    for (UIButton * view in [[self.customBar subviews][0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
             btn.selected=NO;
        }
    }
}
@end
