//
//  QiniuUploader.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^QiniuBlock) (NSDictionary * url);
@interface QiniuUploader : NSObject
//@property (nonatomic, assign) id<QiniuUploaderDelegate> delegate;
@property (nonatomic,strong) NSString * token;
@property (nonatomic,assign) int expires;
+(instancetype)defaultUploader;
-(void)uploadImageToQNFilePath:(UIImage *)image withBlock:(QiniuBlock)block;
- (NSString *)getImagePath:(UIImage *)Image;
@end
