//
//  SRDownloadManager.h
//  dumbbell
//
//  Created by JYS on 17/3/16.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SRDownloadState) {
    SRDownloadStateRunning = 0,//正在下载
    SRDownloadStateSuspended,//暂停下载
    SRDownloadStateCanceled,//取消下载
    SRDownloadStateCompleted,//完成下载
    SRDownloadStateFailed//下载失败
};

@interface SRDownloadModel : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) NSOutputStream *outputStream; // For write datas to file.

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, copy) void (^state)(SRDownloadState state);

@property (nonatomic, copy) void (^progress)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);

@property (nonatomic, copy) void (^completion)(BOOL isSuccess, NSString *filePath, NSError *error);

- (void)openOutputStream;

- (void)closeOutputStream;

@end
