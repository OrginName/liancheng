//
//  CommentView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/7/19.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CommentView.h"
@interface CommentView()
@property (nonatomic,strong)UIButton * btnSend;
@end
@implementation CommentView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:self.textField];
        [self addSubview:self.btnSend];
        self.placeHolder = @"请输入评论内容";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}
-(void)setBtnTitle:(NSString *)btnTitle{
    _btnTitle = btnTitle;
    [self.btnSend setTitle:btnTitle forState:UIControlStateNormal];
}
// 收缩键盘
-(void)dismissKeyBoard:(NSNotification *)notification
{
    [self kebordY:notification flag:1];
}
// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    [self kebordY:notification flag:2];
}
-(void)kebordY:(NSNotification *)notification flag:(int)a{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    WeakSelf
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        weakSelf.center = CGPointMake(weakSelf.center.x, a==1?keyBoardEndY+20:keyBoardEndY-20);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(10, 5, self.width-65, self.height-10);
    self.btnSend.frame = CGRectMake(self.width-50, 0, 40, self.height);
}
-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.width-65, self.height-10)];
        _textField.tag=10;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"请输入评论内容";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _textField;
}
-(UIButton *)btnSend{
    if (!_btnSend) {
        _btnSend = [[UIButton alloc] initWithFrame:CGRectMake(self.width-50, 0, 40, self.height)];
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        _btnSend.backgroundColor = [UIColor clearColor];
        [_btnSend addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSend;
}
-(void)btnClicked{
    if (self.textField.text.length==0) {
        [YTAlertUtil showTempInfo:self.placeHolder];
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendValue)]) {
        [self.delegate sendValue];
    }
}
@end
