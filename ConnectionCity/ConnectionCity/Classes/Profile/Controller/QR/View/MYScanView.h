//
//  MYScanView.h
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/19.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYScanView;
@class MYScanViewStyle;
@protocol MYScanViewDelegate;
@protocol MYScanViewDelegate <NSObject>
@optional
// 闪光灯开启和关闭事件的代理方法
- (void)scanView:(MYScanView *)scanView didChangeTorchMode:(BOOL)torchOn;
@end

#define CUSTOM_SCAN_VIEW_SIZE 1
@interface MYScanView : UIView
@property (nonatomic, weak) id<MYScanViewDelegate> delegate;
@property (nonatomic, assign) BOOL torchOn; // 是否开启闪光灯，默认为NO
/**
 @brief  初始化
 @param frame 位置大小
 @param style 类型
 @return instancetype
 */
-(id)initWithFrame:(CGRect)frame style:(MYScanViewStyle *)style;
/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString*)text;
/**
 *  设备启动完成
 */
- (void)stopDeviceReadying;
/**
 *  开始扫描动画
 */
- (void)startScanAnimation;
/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;
/**
 @brief  根据矩形区域，获取识别兴趣区域
 @param view  视频流显示UIView
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getScanRectWithPreView:(CALayer *)view style:(MYScanViewStyle *)style;

@end




