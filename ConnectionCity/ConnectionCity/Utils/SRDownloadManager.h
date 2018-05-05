//
//  SRDownloadManager.h
//  dumbbell
//
//  Created by JYS on 17/3/16.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRDownloadModel.h"

@interface SRDownloadManager : NSObject

/**
 The directory where the downloaded files are saved, default is .../Library/Caches/SRDownloadManager if not setted.
 */
@property (nonatomic, copy) NSString *downloadedFilesDirectory;

+ (instancetype)sharedManager;

- (void)downloadFile:(NSURL *)URL
               state:(void (^)(SRDownloadState state))state
            progress:(void (^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progress
          completion:(void (^)(BOOL isSuccess, NSString *filePath, NSError *error))completion;

- (BOOL)isDownloadFileCompleted:(NSURL *)URL;

- (NSString *)fileFullPath:(NSURL *)URL;

- (CGFloat)fileDownloadedProgress:(NSURL *)URL;

- (void)deleteFile:(NSURL *)URL;
- (void)deleteAllFiles;

- (void)suspendDownloadURL:(NSURL *)URL;
- (void)suspendAllDownloads;

- (void)resumeDownloadURL:(NSURL *)URL;
- (void)resumeAllDownloads;

- (void)cancelDownloadURL:(NSURL *)URL;
- (void)cancelAllDownloads;

@end
