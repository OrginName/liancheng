//
//  CustomImageScro.h
//  ConnectionCity
//
//  Created by umbrella on 2018/8/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomImageScroDelegate <NSObject>
@optional
//- (void)CustomScroBtnClick:(UIButton *)tag; //声明协议方法
- (void)CustomScroIMGClick:(UIButton *)tag; //声明协议方法
@end

@interface CustomImageScro : UIView<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,assign) id<CustomImageScroDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr;
@end
