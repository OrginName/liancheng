//
//  MYScanView.m
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/19.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import "MYScanView.h"
#import "MYScanViewStyle.h"
#import "MYScanLineAnimation.h"

@interface MYScanView (){
    UILabel *_tipMsgLabel; // 请将二维码放入框内，即可自动扫描
    UIButton *_torchButton; // 闪光灯按钮
}
//扫码区域各种参数
@property (nonatomic, strong) MYScanViewStyle *viewStyle;
//扫码区域
@property (nonatomic,assign)CGRect scanRetangleRect;
//线条扫码动画封装
@property (nonatomic,strong) MYScanLineAnimation *scanLineAnimation;
/**启动相机时 菊花等待*/
@property(nonatomic,strong)UIActivityIndicatorView* activityView;
/**启动相机中的提示文字*/
@property(nonatomic,strong)UILabel *labelReadying;

@end

@implementation MYScanView

-(id)initWithFrame:(CGRect)frame style:(MYScanViewStyle*)style
{
    if (self = [super initWithFrame:frame]){
        self.viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
        _tipMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 36)];
        _tipMsgLabel.font = [UIFont systemFontOfSize:14];
        _tipMsgLabel.textColor = [UIColor whiteColor];
        _tipMsgLabel.textAlignment = NSTextAlignmentCenter;
        _tipMsgLabel.text = @"请扫描二维码";
        [self addSubview:_tipMsgLabel];
        
        _torchButton = [UIButton new];
        [_torchButton setImage:[UIImage imageNamed:@"flashLightw"] forState:UIControlStateNormal];
        [_torchButton setImage:[UIImage imageNamed:@"flashLightb"] forState:UIControlStateSelected];
        [_torchButton addTarget:self action:@selector(torchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _torchButton.bounds = CGRectMake(0, 0, 50, 50);
        [self addSubview:_torchButton];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{
    [self drawScanRect];
}


- (void)startDeviceReadyingWithText:(NSString*)text{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;
    CGSize sizeRetangle = [self getSizeRetangle];
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.centerUpOffset;
    
    // 设备启动状态提示
    if (!_activityView){
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_activityView setCenter:CGPointMake(XRetangleLeft +  sizeRetangle.width/2 - 50, YMinRetangle + sizeRetangle.height/2)];
        
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
        
        CGRect labelReadyRect = CGRectMake(_activityView.frame.origin.x + _activityView.frame.size.width + 10, _activityView.frame.origin.y, 100, 30);
        self.labelReadying = [[UILabel alloc]initWithFrame:labelReadyRect];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.0f];
        _labelReadying.text = text;
        
        [self addSubview:_labelReadying];
        
        [_activityView startAnimating];
    }
    
}

- (void)stopDeviceReadying{
    if (_activityView) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        self.activityView = nil;
        self.labelReadying = nil;
    }
}


/**开始扫描动画*/
- (void)startScanAnimation{
    //线动画
    if (!_scanLineAnimation)
        self.scanLineAnimation = [[MYScanLineAnimation alloc] init];
    [_scanLineAnimation startAnimatingWithRect:_scanRetangleRect
                                        InView:self
                                         Image:_viewStyle.animationImage];
}


/**结束扫描动画*/
- (void)stopScanAnimation {
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }
}


- (void)drawScanRect{
    int XRetangleLeft = _viewStyle.xScanRetangleOffset;
    CGSize sizeRetangle = [self getSizeRetangle];
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = ( CGRectGetHeight(self.bounds) - (sizeRetangle.height + 30 + 25 + _tipMsgLabel.bounds.size.height + _torchButton.bounds.size.height) ) / 2.0f;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //非扫码区域半透明
    {
        //设置非识别区域颜色
        CGContextSetRGBFillColor(context, _viewStyle.red_notRecoginitonArea, _viewStyle.green_notRecoginitonArea,
                                 _viewStyle.blue_notRecoginitonArea, _viewStyle.alpa_notRecoginitonArea);
        //填充矩形
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    if (_viewStyle.isNeedShowRetangle){
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        //CGContextMoveToPoint(context, XRetangleLeft, YMinRetangle);
        //CGContextAddLineToPoint(context, XRetangleLeft+sizeRetangle.width, YMinRetangle);
        CGContextStrokePath(context);
    }
    _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    // 设置Label和按钮的Frame
    _tipMsgLabel.center = CGPointMake(self.bounds.size.width/2.0f, CGRectGetMaxY(_scanRetangleRect) + 30 + _tipMsgLabel.bounds.size.height/2.0f);
    _torchButton.center = CGPointMake(_tipMsgLabel.center.x, CGRectGetMaxY(_tipMsgLabel.frame) + 25 + _torchButton.bounds.size.height/2.0f);
    //画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = _viewStyle.photoframeAngleW;
    int hAngle = _viewStyle.photoframeAngleH;
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.photoframeLineW;// 经验参数：6和4
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    switch (_viewStyle.photoframeAngleStyle){
        case MYScanViewPhotoframeAngleStyle_Outer:
        {
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
        }
            break;
        case MYScanViewPhotoframeAngleStyle_On:
        {
            diffAngle = 0;
        }
            break;
        case MYScanViewPhotoframeAngleStyle_Inner:
        {
            diffAngle = -_viewStyle.photoframeLineW/2;
            
        }
            break;
            
        default:
        {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    //
    CGFloat leftX = XRetangleLeft - diffAngle-1;
    CGFloat topY = YMinRetangle - diffAngle-1;
    CGFloat rightX = XRetangleRight + diffAngle+1;
    CGFloat bottomY = YMaxRetangle + diffAngle+1;
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    CGContextStrokePath(context);
}


// 获取扫描区域的大小
- (CGSize)getSizeRetangle {
    CGFloat XRetangleLeft = _viewStyle.xScanRetangleOffset;
    CGFloat scanViewWidth = self.frame.size.width - XRetangleLeft * 2;
    if (CUSTOM_SCAN_VIEW_SIZE) {
        CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        scanViewWidth = MIN(screenWidth - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    }
    CGSize sizeRetangle = CGSizeMake(scanViewWidth, scanViewWidth);
    if (!_viewStyle.isNeedShowRetangle) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / _viewStyle.whRatio;
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    return sizeRetangle;
}


//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView*)view style:(MYScanViewStyle*)style{
    int XRetangleLeft = style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    if (style.whRatio != 1){
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    //计算兴趣区域
    CGRect rectOfInterest;
    // ref:http://www.cocoachina.com/ios/20141225/10763.html
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                    cropRect.origin.x/size.width,
                                    cropRect.size.height/fixHeight,
                                    cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                    (cropRect.origin.x + fixPadding)/fixWidth,
                                    cropRect.size.height/size.height,
                                    cropRect.size.width/fixWidth);
    }
    return rectOfInterest;
}


#pragma mark -
- (void)setTorchOn:(BOOL)torchOn {
    _torchOn = torchOn;
    _torchButton.selected = torchOn;
}

- (void)torchButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _torchOn = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanView:didChangeTorchMode:)]) {
        [self.delegate scanView:self didChangeTorchMode:_torchOn];
    }
}


@end
