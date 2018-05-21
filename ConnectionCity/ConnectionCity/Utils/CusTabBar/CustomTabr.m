//
//  CustomTabr.m
//  testBar
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 qt. All rights reserved.
//

#import "CustomTabr.h"
#import "UIButton+ImageTitleSpacing.h"
/** 当前屏幕宽度 */
#define kScreenWidth       [UIScreen mainScreen].bounds.size.width
/** 当前屏幕高度 */
#define kScreenHeight      [UIScreen mainScreen].bounds.size.height
#define BARHEIGHT 50
@interface CustomTabr()
{
    UIButton * _tmpBtn;
}
@property (nonatomic,strong) UIView * view_Tabbar;
@property (nonatomic,strong) NSArray * selectArr;
@property (nonatomic,strong) NSArray * DeSlectArr;
@property (nonatomic,strong) NSArray * TitleArr;
//@property (nonatomic,strong) NSArray * VCArr;

@end
@implementation CustomTabr

-(instancetype)initWithFrame:(CGRect)frame withSelectArr:(NSArray *)selectArr withDeSlectArr:(NSArray *)DeSlectArr withTitleArr:(NSArray *)TitleArr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectArr = selectArr;
        self.DeSlectArr = DeSlectArr;
        self.TitleArr = TitleArr;
        [self TabbarDefulet];
        [self addSubview:self.view_Tabbar];
    }
    return self;
}
-(void)TabbarDefulet{
    _tabBarColor = [UIColor whiteColor];
    _titleFont = 12;
    _titleSelectColor = [UIColor orangeColor];
    _titleDeSelctColor = [UIColor grayColor];
}
-(void)setTabBarColor:(UIColor *)tabBarColor{
    _tabBarColor = tabBarColor;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _view_Tabbar.backgroundColor = _tabBarColor;
    
    self.view_Tabbar.frame = CGRectMake(0, 0, self.frame.size.width, BARHEIGHT);
    [self initBtn];
}
//选择tabbar
-(void)ChooseTab:(UIButton *)sender{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else  if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:sender.tag];
    }
}
#pragma mark --- 懒加载控件------
-(UIView *)view_Tabbar{
    if (!_view_Tabbar) {
        _view_Tabbar = [[UIView alloc] init];
        _view_Tabbar.backgroundColor = _tabBarColor;
    }
    return _view_Tabbar;
}
-(void)initBtn{
    for (int i=0; i<self.selectArr.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/self.selectArr.count), 2, kScreenWidth/self.selectArr.count, BARHEIGHT)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:self.titleFont];
        [btn setTitle:self.TitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        [btn setTitleColor:self.titleDeSelctColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.selectArr[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:self.DeSlectArr[i]] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:15];
        
        [btn addTarget:self action:@selector(ChooseTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view_Tabbar addSubview:btn];
    }
}
@end
