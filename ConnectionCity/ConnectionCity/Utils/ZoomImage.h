//
//  ZoomImage.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoomImage : NSObject
/**
 *@brief点击图片放大,再次点击缩小
 *
 *@param oldImageView 头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

@end
