//
//  MyQRController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyQRController.h"
#import <CoreImage/CoreImage.h>
#import "privateUserInfoModel.h"

@interface MyQRController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

@implementation MyQRController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的二维码";
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.bgView.layer.cornerRadius = 5;
    self.headImgV.layer.cornerRadius = 5;
    self.headImgV.clipsToBounds = YES;
    [self requestV1PrivateUserInfo];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCoreImage:(NSString *)codeStr  centerImage:(UIImage *)centerImage{
    
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[codeStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg=filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生存的图片
    ciImg=colorFilter.outputImage;
    
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg=[ciImg imageByApplyingTransform:scale];
    
    //    self.imgView.image=[UIImage imageWithCIImage:ciImg];
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //7.2将二维码的图片画入
    //BSXPCMessage received error for message: Connection interrupted   why??
    //    [img drawInRect:CGRectMake(10, 10, img.size.width-20, img.size.height-20)];
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //7.3在中心划入其他图片
    
    UIImage *centerImg=centerImage;
    
    CGFloat centerW=70;
    CGFloat centerH=70;
    CGFloat centerX=(img.size.width-70)*0.5;
    CGFloat centerY=(img.size.height -70)*0.5;
    
    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    //设置图片
    self.imageView.image = finalImg;
    self.imageView.userInteractionEnabled = YES;
    //长按手势识别器
    UILongPressGestureRecognizer *pressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    [self.imageView addGestureRecognizer:pressGesture];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)uilpgr {
    
    if (uilpgr.state != UIGestureRecognizerStateBegan){
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
// 存相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(!error){
        NSLog(@"保存成功");
        [YTAlertUtil showTempInfo:@"保存成功"];
    }else{
        NSLog(@"保存失败");
        [YTAlertUtil showTempInfo:@"保存失败"];

    }
}
#pragma mark - 数据请求
- (void)requestV1PrivateUserInfo {
    //获取用户信息
    WeakSelf
    [YSNetworkTool POST:v1PrivateUserInfo params:nil showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        privateUserInfoModel *userInfoModel = [privateUserInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
        [YSAccountTool saveUserinfo:userInfoModel];
        
        [weakSelf.headImgV sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headImage] placeholderImage:[UIImage imageNamed:@"our-center-1"]];
        weakSelf.nameLab.text = userInfoModel.nickName;
        weakSelf.addressLab.text = [NSString stringWithFormat:@"%@",[YSTools dx_isNullOrNilWithObject:userInfoModel.cityName]?@"":userInfoModel.cityName];
        [weakSelf createCoreImage:kAccount.userId centerImage:[UIImage imageWithData:[NSData  dataWithContentsOfURL:[NSURL URLWithString:userInfoModel.headImage]]]];
    } failure:nil];
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
