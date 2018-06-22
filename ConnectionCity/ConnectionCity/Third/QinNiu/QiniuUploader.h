//
//  QiniuUploader.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol QiniuUploaderDelegate <NSObject>
@optional

- (void)uploadWithQNResponseInfo:(QNResponseInfo*)info fileUrl:(NSURL *)url resp:(NSDictionary *)resp;

- (void)uploadingProgress:(float)percent fileUrl:(NSURL *)url;

- (void)uploadFinish;

@end
@interface QiniuUploader : NSObject
@property (nonatomic, assign) id<QiniuUploaderDelegate> delegate;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,assign) int expires;
+(instancetype)defaultUploader;
//取消上传某个文件，根据fileUrl 判断
- (void)cancelUploadWithFileUrl:(NSURL *)url;

//继续上传某个文件，根据fileUrl 判断
- (void)continueUploadWithFileUrl:(NSURL *)url;

//某个任务上传进度
- (float)uploadPersentOfFileUrl:(NSURL *)fileUrl;

//取消所有上传
- (void)cancelAllTask;

//继续所有任务
- (void)continueAllTask;

//任务是否正在上传
- (BOOL)isUploadingOfFileurl:(NSURL *)fileUrl;

@end
