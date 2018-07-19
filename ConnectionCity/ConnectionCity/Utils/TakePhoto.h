//
//  TakePhoto.h
//  TakePhoto
//
//  Created by JYS on 16/2/15.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//使用block 返回值
typedef void(^sendPictureBlock)(UIImage *image);

@interface TakePhoto : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy)sendPictureBlock pictureBlock;

+ (TakePhoto *)sharedPhoto;
- (void)sharePicture:(sendPictureBlock)block;
- (void)hehe:(sendPictureBlock)block;

@end









































