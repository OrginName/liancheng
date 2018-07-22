//
//  ZoomImage.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ZoomImage.h"

static CGRect oldframe;
@implementation ZoomImage
+(void)showImage:(UIImageView*)avatarImageView {
     UIImage *image =avatarImageView.image;
     // 获得根窗口
     UIWindow *window =[UIApplication sharedApplication].keyWindow;
     UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
     oldframe =[avatarImageView convertRect:avatarImageView.bounds toView:window];
     backgroundView.backgroundColor =[UIColor blackColor];
     backgroundView.alpha =0.5;
     UIImageView *imageView =[[UIImageView alloc]initWithFrame:oldframe];
     imageView.image =image;
     imageView.tag =1;
     [backgroundView addSubview:imageView];
     [window addSubview:backgroundView];
     //点击图片缩小的手势
     UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
     [backgroundView addGestureRecognizer:tap];
     [UIView animateWithDuration:0.3 animations:^{
          imageView.frame =CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
          backgroundView.alpha =1;
         }];
}
+(void)hideImage:(UITapGestureRecognizer *)tap{
     UIView *backgroundView =tap.view;
     UIImageView *imageView =(UIImageView *)[tap.view viewWithTag:1];
     [UIView animateWithDuration:0.3 animations:^{
          imageView.frame =oldframe;
          backgroundView.alpha =0;
         } completion:^(BOOL finished) {
              [backgroundView removeFromSuperview];
             }];
}
@end
