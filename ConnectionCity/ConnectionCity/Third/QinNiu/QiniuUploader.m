//
//  QiniuUploader.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "QiniuUploader.h"
#import <QiniuSDK.h>
#import "GTMBase64.h"
#include <CommonCrypto/CommonCrypto.h>
#define AccessKey  @"Ax6OZsE9cKwQmNMzdCNSeOfKGBfj7pWUXkrGOLxg"
#define SecretKey  @"AxDY8hElECB_UL1QWEDJjyTr4eDYiJ7PFlI1VbhP"
@interface QiniuUploader()
@property (nonatomic, strong) QNUploadManager *upmanager;
@property (nonatomic, strong) NSMutableDictionary *flagDic;
@property (nonatomic, strong) NSMutableArray *uploadTaskArr;
@property (nonatomic, strong) NSMutableDictionary *uploadingTaskDic;
@end
@implementation QiniuUploader
+(instancetype)defaultUploader{
    
    static QiniuUploader *uploader= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uploader = [[self alloc]init];
        uploader.token = [uploader makeToken];
    });
    return uploader;
}
- (void)uploadDataWithFileUrl:(NSURL *)fileUrl
                      withKey:(NSString *)key
                        token:(NSString *)token{
    [self uploadObject:fileUrl withKey:key token:token];
    
}

- (void)uploadObject:(NSURL*)fileurl
             withKey:(NSString *)key
               token:(NSString *)token{
    
    [self.flagDic setValue:@(0) forKey:fileurl.path];
    //option
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent) {
        [self.uploadingTaskDic setObject:@(percent) forKey:fileurl.path];
        if (percent >= 1) {
            [self.flagDic setValue:@(1) forKey:fileurl.path];
            [self.flagDic removeObjectForKey:fileurl.path];
//            [self remo  veTaskWithFileurl:fileurl];
            //[self.uploadingTaskDic removeObjectForKey:fileurl.path];
            
            if ([self.delegate respondsToSelector:@selector(uploadFinish)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate uploadFinish];
                });
            }else{
                NSLog(@"WORNING: 代理方法：(uploadFinish)未实现");
            }
        }
        // NSLog(@"---***---上传进度：%f-----*",percent);
        if ([self.delegate respondsToSelector:@selector(uploadingProgress:fileUrl:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate uploadingProgress:percent fileUrl:fileurl];
            });
        }else{
            NSLog(@"WORNING: 代理方法：(uploadingProgress:fileUrl:)未实现");
        }
        
    } params:nil checkCrc:NO cancellationSignal: ^BOOL () {
        return [[self.flagDic objectForKey:fileurl.path]boolValue];
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([fileurl isKindOfClass:[NSURL class]]) {
        
        [self.upmanager putFile:[(NSURL*)fileurl path]
                            key:key
                          token:token
                       complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           [self uploadWithQNResponseInfo:info key:key resp:resp fileUrl:fileurl];
                       } option:opt];
    }
}

- (void)uploadWithQNResponseInfo:(QNResponseInfo*)info key:(NSString *)key resp:(NSDictionary *)resp fileUrl:url{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([self.delegate respondsToSelector:@selector(uploadWithQNResponseInfo:fileUrl:resp:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate uploadWithQNResponseInfo:info
                                            fileUrl:url
                                               resp:resp];
        });
        
    }else{
        NSLog(@"WORNING: 代理方法：(uploadWithQNResponseInfo:fileUrl:resp:)未实现");
    }
}

//lazy upmanager
-(QNUploadManager *)upmanager{
    if (_upmanager==nil) {
        NSError *error = nil;
        QNFileRecorder *recorder = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"RAYUploadFileRecord"] error:&error];
        _upmanager = [[QNUploadManager alloc]initWithRecorder:recorder];
    }
    return _upmanager;
}

-(NSMutableDictionary *)flagDic{
    if (_flagDic == nil) {
        _flagDic = [[NSMutableDictionary alloc]init];
    }
    return _flagDic;
}

-(NSMutableArray *)uploadTaskArr{
    if (_uploadTaskArr == nil) {
        _uploadTaskArr = [[NSMutableArray alloc]init];
    }
    return _uploadTaskArr;
}

-(NSMutableDictionary *)uploadingTaskDic{
    if (_uploadingTaskDic == nil) {
        _uploadingTaskDic = [[NSMutableDictionary alloc]init];
    }
    return _uploadingTaskDic;
}

//取消上传
- (void)cancelUploadWithFileUrl:(NSURL *)url{
    [self.flagDic setObject:@1 forKey:url.path];
}

//取消所有上传
- (void)cancelAllTask{
    for (NSString *key in self.flagDic.allKeys) {
        [self.flagDic setObject:@1 forKey:key];
    }
    
}

//继续上传
//- (void)continueUploadWithFileUrl:(NSURL *)url{
//    [self.flagDic setObject:@0 forKey:url.path];
//    RAYUploadFile *file = [self fileWithFileUrl:url];
//    if (file == nil) {
//        return;
//    }
//    NSLog(@"继续上传%@,%@",file.key,file.token);
//    [self uploadObject:file.fileurl withKey:file.key token:file.token];
//}

- (void)continueAllTask{
    for (NSString *key in self.flagDic.allKeys) {
        NSURL *url = [NSURL fileURLWithPath:key];
        [self continueUploadWithFileUrl:url];
    }
    
}

//- (RAYUploadFile*)fileWithFileUrl:(NSURL*)url{
//
//    for (RAYUploadFile *file in self.uploadTaskArr) {
//        if ([file.fileurl isEqual:url]) {
//            return file;
//        }
//    }
//    NSLog(@"Error：任务不存在或已经结束");
//    return nil;
//}

//- (void)removeTaskWithFileurl:(NSURL *)url{
//    RAYUploadFile *file = [self fileWithFileUrl:url];
//    if (file == nil) {
//        return;
//    }
//    [self.uploadTaskArr removeObject:file];
//}

- (float)uploadPersentOfFileUrl:(NSURL *)fileUrl{
    NSNumber *persent = [self.uploadingTaskDic objectForKey:fileUrl.path];
    return persent.floatValue;
}

- (BOOL)isUploadingOfFileurl:(NSURL *)fileUrl{
    if ([[self.flagDic objectForKey:fileUrl.path] isEqual:@0]) {
        return YES;
    }
    return NO;
}
- (NSString *)makeToken
{
    if (AccessKey.length==0||SecretKey.length==0) {
        return @"";
    }
    const char *secretKeyStr = [SecretKey UTF8String];
    
    NSString *policy = [self marshal];
    
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
    
    NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  AccessKey, encodedDigest, encodedPolicy];
    
    return token;//得到了token
}
- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);//返回当前系统时间
    //@property (nonatomic , assign) int expires; 怎么定义随你...
    deadline += (self.expires > 0) ? self.expires : 3600; // +3600秒,即默认token保存1小时.
    
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //users是我开辟的公共空间名（即bucket），aaa是文件的key，
    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
    //传users:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
    [dic setObject:@"oem-connect" forKey:@"scope"];//根据
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSString *json = [dic mj_JSONString];
    return json;
}
@end
