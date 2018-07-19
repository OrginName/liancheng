//
//  CommentView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/7/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建协议
@protocol CommentViewDelegate <NSObject>
@optional
- (void)sendValue; //声明协议方法
@end
@interface CommentView : UIView
@property (nonatomic,assign) id<CommentViewDelegate>delegate;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) NSString * placeHolder;//输入框placeHolder
@property (nonatomic,strong) NSString * btnTitle;//按钮标题
@end
