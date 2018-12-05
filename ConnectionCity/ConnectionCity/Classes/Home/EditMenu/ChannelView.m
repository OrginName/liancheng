//
//  ChannelView.m
//  标签栏
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 xushuo. All rights reserved.
//

#import "ChannelView.h"
#import "MenuMo.h"
@interface ChannelView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic,strong) UIButton * closeBtn;

@property (nonatomic, strong) NSMutableArray *upBtn;
@property (nonatomic, strong) NSMutableArray *belowBtn;

@property (nonatomic, strong) NSMutableArray <NSValue*>*upFranmeArr;
@property (nonatomic, strong) NSMutableArray <NSValue*>*belowFranmeArr;

@property (nonatomic, weak) UILabel *channelLabel;
@property (nonatomic, weak) UILabel *channelLabel1;
@property (nonatomic, weak) UIButton *compileBtn;
@end

@implementation ChannelView

-(NSMutableArray *)upBtn{
    if (!_upBtn) {
        _upBtn = [NSMutableArray array];
    }
    return _upBtn;
}

-(NSMutableArray *)belowBtn{
    if (!_belowBtn) {
        _belowBtn = [NSMutableArray array];
    }
    return _belowBtn;
}


-(NSMutableArray *)upFranmeArr{
    if (!_upFranmeArr) {
        _upFranmeArr = [NSMutableArray array];
    }
    return _upFranmeArr;
}

-(NSMutableArray *)belowFranmeArr{
    if (!_belowFranmeArr) {
        _belowFranmeArr = [NSMutableArray array];
    }
    return _belowFranmeArr;
}
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(5, 5, 30, 30);
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(Close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
static CGFloat btnW;
static CGFloat btnH;

- (void)willMoveToSuperview:(UIView *)newSuperview;
{
    if (self.btnNumber == 0) {
        self.btnNumber = 4;
    }
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    btnW = (self.frame.size.width-20-(self.btnNumber-1)*10)/self.btnNumber;
    btnH = btnW/2;
    
    [self addSubview:self.closeBtn];
    self.ScrollView = [[UIScrollView alloc]init];
    self.ScrollView.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40); 
    [self addSubview:self.ScrollView];
    
    UILabel *compileLabel = [[UILabel alloc]init];
    compileLabel.text = @"我的频道";
    compileLabel.font = [UIFont systemFontOfSize:15.0f];
    compileLabel.frame = CGRectMake(10, 0, 70, 50);
    [self.ScrollView addSubview:compileLabel];
    
    UILabel *compileLabel1 = [[UILabel alloc]init];
    compileLabel1.text = @"长按可拖动排序";
    compileLabel1.textAlignment = NSTextAlignmentLeft;
    compileLabel1.textColor = [UIColor lightGrayColor];
    compileLabel1.font = [UIFont systemFontOfSize:12.0f];
    compileLabel1.frame = CGRectMake(80, 0, 100, 50);
    [self.ScrollView addSubview:compileLabel1];
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.frame = CGRectMake(10, compileLabel.frame.size.height, self.ScrollView.frame.size.width-20, ((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)*btnH+10*((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)+100 + btnH);
    [self.ScrollView addSubview:self.backgroundView];
    
    self.ScrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.backgroundView.frame)+btnH);
    
    
    UIButton *compileBtn = [[UIButton alloc]init];
    [compileBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [compileBtn setTitle:@"完成" forState:UIControlStateNormal];
    [compileBtn addTarget:self action:@selector(compileBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [compileBtn setTitle:@"完成" forState:UIControlStateSelected];
    compileBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    compileBtn.frame = CGRectMake(self.ScrollView.frame.size.width-60, 0, 50, 50);
    [self.ScrollView addSubview:compileBtn];
    self.compileBtn = compileBtn;
 
    for (int i = 0; i < self.upBtnDataArr.count; i ++) {
        int a = (i/self.btnNumber);
        UIButton *btn  = [self addBtnFrame:CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH)];
        [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[self.upBtnDataArr[i] name] forState:UIControlStateNormal];
        btn.tag = [[self.upBtnDataArr[i] ID] integerValue];
        //添加手势
        [self addLongPress:btn];
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.upBtn addObject:btn];
    }
    
    UILabel *channelLabel = [[UILabel alloc]init];
    channelLabel.text = @"频道推荐";
    channelLabel.font = compileLabel.font;
    channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), 70, 100-btnH);
    [self.backgroundView addSubview:channelLabel];
    self.channelLabel = channelLabel;
    
    UILabel *channelLabel1 = [[UILabel alloc]init];
    channelLabel1.text = @"点击添加频道";
    channelLabel1.textColor = [UIColor lightGrayColor];
    channelLabel1.textAlignment = NSTextAlignmentLeft;
    channelLabel1.font = [UIFont systemFontOfSize:12.0f];
    channelLabel1.frame = CGRectMake(75,CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue),100,100-btnH);
    [self.backgroundView addSubview:channelLabel1];
    self.channelLabel1 = channelLabel1;
    
    
    for (int j = 0; j < self.belowBtnDataArr.count; j ++) {
        int b = (j/self.btnNumber);
        UIButton *btn  = [self addBtnFrame:CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+compileLabel.frame.size.height*2, btnW, btnH)];
        btn.tag = [[self.belowBtnDataArr[j] ID] integerValue];
        [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"+  %@",[self.belowBtnDataArr[j] name]] forState:UIControlStateNormal];
        btn.tag =[[self.belowBtnDataArr[j] ID] longLongValue];
        [self.belowFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.belowBtn addObject:btn];
    }
    
    UIImageView *jianbian = [[UIImageView alloc]init];
    jianbian.image = [UIImage imageNamed:@"渐变"];
    jianbian.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
    [self addSubview:jianbian];
    [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (UIImageView *militaryFork in obj.subviews) {
            if ([militaryFork isKindOfClass:[UIImageView class]]) {
                militaryFork.hidden = NO;
                if ([obj.titleLabel.text isEqualToString:[self.upBtnDataArr[0] name]] && !self.IS_compileFirstBtn) {
                    militaryFork.hidden = YES;
                }
            }
        }
    }];
}
//编辑
-(void)compileBtn:(UIButton *)btn{
//    if (btn.selected) {
        NSMutableArray *upBtnText = [NSMutableArray array];
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (UIImageView *militaryFork in obj.subviews) {
                if ([militaryFork isKindOfClass:[UIImageView class]]) {
                    militaryFork.hidden = YES;
                }
            }
            [upBtnText addObject:[NSString stringWithFormat:@"%ld",obj.tag]];
        }];
        
        if (self.dataBlock) {
            self.dataBlock(upBtnText);
        }
//    }
//        else{
    
//        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            for (UIImageView *militaryFork in obj.subviews) {
//                if ([militaryFork isKindOfClass:[UIImageView class]]) {
//                    militaryFork.hidden = NO;
//                    if ([obj.titleLabel.text isEqualToString:self.upBtnDataArr[0]] && !self.IS_compileFirstBtn) {
//                        militaryFork.hidden = YES;
//                    }
//                }
//            }
//
//        }];
        
//    }
//    btn.selected = !btn.selected;
}
-(void)Close:(UIButton *)btn{
    if (self.closeBlock) {
        self.closeBlock(btn);
    }
}

-(UIButton *)addBtnFrame:(CGRect)frame{
    UIButton *btn  = [[UIButton alloc]init];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0].CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:self.btnTextFont];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backgroundView addSubview:btn];
    
    UIImageView *militaryFork = [[UIImageView alloc]init];
    CGFloat militaryForkWH = btn.frame.size.width*0.25;
    militaryFork.layer.masksToBounds = YES;
    militaryFork.layer.cornerRadius = militaryForkWH/2;
    militaryFork.frame = CGRectMake(btn.frame.size.width-militaryForkWH+2, -2, militaryForkWH, militaryForkWH);
    militaryFork.image = [UIImage imageNamed:@"叉号2"];
    militaryFork.hidden = YES;
    [btn addSubview:militaryFork];
    
    return btn;
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
//    if (!self.compileBtn.selected) {
//        return;
//    }
    UIView *view = paramSender.view;
    static  CGRect viewFrame;
    if (paramSender.state == UIGestureRecognizerStateBegan){
        [self.backgroundView insertSubview:view atIndex:self.backgroundView.subviews.count-1];
        viewFrame = view.frame;
        CGAffineTransform transform = CGAffineTransformScale(view.transform, 1.2f, 1.2f);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.0f];
        [view setTransform:transform];
        [UIView commitAnimations];
    }
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        view.center = location;
        
        for (int i = 0; i < self.upBtn.count; i ++) {
            if (i == 0 && !self.IS_compileFirstBtn) continue;
            UIButton *btn = self.upBtn[i];
            if (btn == view)continue;
            if (CGRectContainsPoint(btn.frame,location)) {
                [self.upBtn removeObject:view];
                [self.upBtn insertObject:view atIndex:i];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj != view) {
                            obj.frame = [self.upFranmeArr[idx] CGRectValue];
                        }else{
                            viewFrame = [self.upFranmeArr[idx] CGRectValue];
                        }
                        
                    }];
                }];
                
                break;
            }
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = viewFrame;
        }];
    }
}
//点击上btn
-(void)clickUpBtn:(UIButton *)btn{
//    if (!self.compileBtn.selected) {
//        return;
//    }
    if (self.upBtn.count<=1) {
        return [YTAlertUtil showTempInfo:@"请至少保留一个功能页"];
    }
    if ([btn.titleLabel.text isEqualToString:[self.upBtnDataArr[0] name]] && !self.IS_compileFirstBtn) {
        return;
    }
    for (UIImageView *militaryFork in btn.subviews) {
        if ([militaryFork isKindOfClass:[UIImageView class]]) {
            militaryFork.hidden = YES;
        }
    }
    [btn removeTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];

    [btn removeGestureRecognizer:btn.gestureRecognizers[0]];
    
    [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.upBtn removeObject:btn];
    [self.upFranmeArr removeObjectAtIndex:self.upFranmeArr.count-1];
    [self.belowBtn insertObject:btn atIndex:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = self.upFranmeArr[idx].CGRectValue;
        }];
    }];
    
    [self.belowFranmeArr removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger j, BOOL * _Nonnull stop) {
            int b = ((int)j/self.btnNumber);
            if (![obj.titleLabel.text containsString:@"+  "]) {
                [obj setTitle:[NSString stringWithFormat:@"+  %@",obj.titleLabel.text] forState:UIControlStateNormal];
            }
            obj.frame = CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnW, btnH);
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
    }];

    [UIView animateWithDuration:0.3 animations:^{
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
        self.channelLabel1.frame = CGRectMake(75, self.channelLabel.frame.origin.y, self.channelLabel1.frame.size.width, self.channelLabel1.frame.size.height);
    }];
}
//添加长按手势
-(void)addLongPress:(UIButton *)btn{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = 100.0f;
    longPress.minimumPressDuration = 1.0;
    [btn addGestureRecognizer:longPress];
}

//点击下Btn
-(void)clickBelowBtn:(UIButton *)btn{
//    if (self.compileBtn.selected) {
        for (UIImageView *militaryFork in btn.subviews) {
            if ([militaryFork isKindOfClass:[UIImageView class]]) {
                militaryFork.hidden = NO;
            }
        }
//    }
    [btn removeTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
  
    [self addLongPress:btn];
    
    [self.belowFranmeArr removeObjectAtIndex:self.belowFranmeArr.count-1];
    [self.belowBtn removeObject:btn];
    [self.upBtn addObject:btn];
    int i = (int)self.upBtn.count-1;
    int a = ((int)i/self.btnNumber);
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame =  CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH);
        if ([btn.titleLabel.text containsString:@"+  "]) {
            [btn setTitle:[btn.titleLabel.text stringByReplacingOccurrencesOfString:@"+  " withString:@""] forState:UIControlStateNormal];
        }
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
        self.channelLabel1.frame = CGRectMake(75, self.channelLabel.frame.origin.y, self.channelLabel1.frame.size.width, self.channelLabel1.frame.size.height);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int b = ((int)idx/self.btnNumber);
            CGRect btnFrame = self.belowFranmeArr[idx].CGRectValue;
            obj.frame = CGRectMake(btnFrame.origin.x,  b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnFrame.size.width, btnFrame.size.height);
        }];
    }];
}

@end
