//
//  MYScanViewStyle.h
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/19.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
// 枚举类型
/** 扫码区域动画效果 */
typedef enum MYScanViewAnimationStyle {
    MYScanViewAnimationStyle_LineMove, // 线条上下移动
    MYScanViewAnimationStyle_NetGrid,//网格
    MYScanViewAnimationStyle_LineStill,//线条停止在扫码区域中央
    MYScanViewAnimationStyle_None,    //无动画
} MYScanViewAnimationStyle;


/** 扫码区域4个角位置类型 */
typedef enum MYScanViewPhotoframeAngleStyle {
    MYScanViewPhotoframeAngleStyle_Inner,//内嵌，一般不显示矩形框情况下
    MYScanViewPhotoframeAngleStyle_Outer,//外嵌,包围在矩形框的4个角
    MYScanViewPhotoframeAngleStyle_On   //在矩形框的4个角上，覆盖
} MYScanViewPhotoframeAngleStyle;


/** 中间取景框的风格 */
@interface MYScanViewStyle : NSObject

#pragma mark -中心位置矩形框
/** 是否需要绘制扫码矩形框，默认YES */
@property (nonatomic, assign) BOOL isNeedShowRetangle;
/** 默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比 */
@property (nonatomic, assign) CGFloat whRatio;
/** 矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移 */
@property (nonatomic, assign) CGFloat centerUpOffset;
/** 矩形框(视频显示透明区)域离界面左边及右边距离，默认60 */
@property (nonatomic, assign) CGFloat xScanRetangleOffset;
/** 矩形框线条颜色 */
@property (nonatomic, strong) UIColor *colorRetangleLine;
@property (nonatomic, assign) MYScanViewPhotoframeAngleStyle photoframeAngleStyle; // 扫码区域的4个角类型
// 4个角的颜色
@property (nonatomic, strong) UIColor *colorAngle;
// 扫码区域4个角的宽度和高度
@property (nonatomic, assign) CGFloat photoframeAngleW;
@property (nonatomic, assign) CGFloat photoframeAngleH;
@property (nonatomic, assign) CGFloat photoframeLineW; // 扫码区域4个角的线条宽度,默认6，建议8到4之间
@property (nonatomic, assign) MYScanViewAnimationStyle anmiationStyle; // 扫码动画效果:线条或网格
@property (nonatomic,strong) UIImage *animationImage; // 动画效果的图像，如线条或网格的图像
#pragma mark -非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
@property (nonatomic, assign) CGFloat red_notRecoginitonArea;
@property (nonatomic, assign) CGFloat green_notRecoginitonArea;
@property (nonatomic, assign) CGFloat blue_notRecoginitonArea;
@property (nonatomic, assign) CGFloat alpa_notRecoginitonArea;

@end
