//
//  CustomPlayer.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, LPAVPlayerStatus) {
    LPAVPlayerStatusReadyToPlay = 0, // 准备好播放
    LPAVPlayerStatusLoadingVideo,    // 加载视频
    LPAVPlayerStatusPlayEnd,         // 播放结束
    LPAVPlayerStatusCacheData,       // 缓冲视频
    LPAVPlayerStatusCacheEnd,        // 缓冲结束
    LPAVPlayerStatusPlayStop,        // 播放中断 （多是没网）
    LPAVPlayerStatusItemFailed,      // 视频资源问题
    LPAVPlayerStatusEnterBack,       // 进入后台
    LPAVPlayerStatusBecomeActive,    // 从后台返回
};
@protocol LPAVPlayerDelegate <NSObject>

@optional
// 数据刷新
- (void)refreshDataWith:(NSTimeInterval)totalTime Progress:(NSTimeInterval)currentTime LoadRange:(NSTimeInterval)loadTime;
// 状态/错误 提示
- (void)promptPlayerStatusOrErrorWith:(LPAVPlayerStatus)status;

@end
@interface CustomPlayer : UIView
@property (nonatomic, weak) id<LPAVPlayerDelegate>delegate;


// 视频总长度
@property (nonatomic, assign) NSTimeInterval totalTime;
// 视频总长度
//@property (nonatomic, assign) NSTimeInterval currentTime;
// 缓存数据
@property (nonatomic, assign) NSTimeInterval loadRange;


/**
 准备播放器
 
 @param videoPath 视频地址
 */
//- (void)setupPlayerWith:(NSString *)videoPath;
- (void)setupPlayerWith:(NSURL *)videoURL;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 播放|暂停 */
- (void)playOrPause:(void (^)(BOOL isPlay))block;

/** 拖动视频进度 */
- (void)seekPlayerTimeTo:(NSTimeInterval)time;

/** 跳动中不监听 */
- (void)startToSeek;
//获取视频第一帧图片
- (UIImage*) getVideoPreViewImage:(NSString *)videoURL;
/**
 切换视频
 
 @param videoPath 视频地址
 */
//- (void)replacePalyerItem:(NSString *)videoPath;
- (void)replacePalyerItem:(NSURL *)videoURL;
@end
