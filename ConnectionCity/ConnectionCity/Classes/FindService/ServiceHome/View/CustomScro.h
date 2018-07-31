//
//  CustomScro.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/29.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScroDelegate <NSObject>
@optional
- (void)CustomScroBtnClick:(UIButton *)tag; //声明协议方法
@end

@interface CustomScro : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,assign)id<CustomScroDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arr flag:(BOOL) flag;
@end
