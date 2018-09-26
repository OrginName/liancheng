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
#define AccessKey  @"i68KauW8I0jssYo4prrjJMQWD2iDQjaUGblB_iLy"
#define SecretKey @"XgN202cVEpG7Al4iLEH8li0xclP6aPBRMdeafHcZ"
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
-(void)uploadImageToQNFilePath:(UIImage *)image withBlock:(QiniuBlock)block1{
    
    NSString * filePath = [self getImagePath:image];
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"Ipercent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"Iinfo ===== %@", info);
        NSLog(@"Iresp ===== %@", resp);
        block1(resp);
    }
                option:uploadOption];
    
}
-(void)uploadVideoToQNFilePath:(NSString *)videoStr withBlock:(QiniuBlock)block1{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"Vpercent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:videoStr key:nil token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"Vinfo ===== %@", info);
        NSLog(@"Vresp ===== %@", resp);
        block1(resp);
    }
                option:uploadOption];
    
}
//照片获取本地路径转换
- (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
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
    [dic setObject:@"liancheng" forKey:@"scope"];//根据
    [dic setObject:deadlineNumber forKey:@"deadline"];
    NSString *json = [dic mj_JSONString];
    return json;
}
@end
