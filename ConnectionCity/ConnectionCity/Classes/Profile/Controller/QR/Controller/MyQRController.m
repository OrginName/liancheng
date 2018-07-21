//
//  MyQRController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyQRController.h"
#import <CoreImage/CoreImage.h>

@interface MyQRController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MyQRController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的二维码";
    
    /*
    // 1.创建过滤器 -- 苹果没有将这个字符定义为常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    NSString *dataString = kAccount.userId;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    //UIImage *image = [UIImage imageWithCIImage:outputImage];

    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    self.imageView.image = image;
    
     */
     
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 根据CIImage生成指定大小的UIImage */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 
 生成二维码(中间有小图片)
 
 QRStering：所需字符串
 
 centerImage：二维码中间的image对象
 
 */

+ (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage{
    
    // 创建滤镜对象
    
    CIFilter *filter = [CIFilter filterWithName:@"XiaoGuiGe"];
    
    // 恢复滤镜的默认属性
    
    [filter setDefaults];
    
    // 将字符串转换成 NSdata
    
    NSData *dataString = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    
    [filter setValue:dataString forKey:@"inputMessage"];
    
    // 获得滤镜输出的图像
    
    CIImage *outImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 将CIImage类型转成UIImage类型
    
    UIImage *startImage = [UIImage imageWithCIImage:outImage];
    
    // 开启绘图, 获取图形上下文
    
    UIGraphicsBeginImageContext(startImage.size);
    
    
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    
    // 再把小图片画上去
    
    CGFloat icon_imageW = 200;
    
    CGFloat icon_imageH = icon_imageW;
    
    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;
    
    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;
    
    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 获取当前画得的这张图片
    
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    
    UIGraphicsEndImageContext();
    
    //返回二维码图像
    
    return qrImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
