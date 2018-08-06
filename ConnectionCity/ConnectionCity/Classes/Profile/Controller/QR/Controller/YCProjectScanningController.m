//
//  YCProjectScanningController.m
//  YingCai
//
//  Created by Yanyan Jiang on 2018/1/4.
//  Copyright © 2018年 Yanyan Jiang. All rights reserved.
//

#import "YCProjectScanningController.h"
#import <AVFoundation/AVFoundation.h>
#import "MYScanView.h"
#import "MYScanViewStyle.h"

@interface YCProjectScanningController ()<AVCaptureMetadataOutputObjectsDelegate,MYScanViewDelegate>
@property (strong , nonatomic) AVCaptureDevice *device;
@property (strong , nonatomic) AVCaptureDeviceInput *input;
@property (strong , nonatomic) AVCaptureMetadataOutput *output;
@property (strong , nonatomic) AVCaptureSession *session;
@property (strong , nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong , nonatomic) MYScanView *qrScanView;
@property (strong , nonatomic) MYScanViewStyle *style;
@property (strong , nonatomic) UIAlertController *alertController;
@end

@implementation YCProjectScanningController
#pragma mark -ViewCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫一扫";
    [self drawScanView];
    [self performSelector:@selector(beginScan) withObject:nil afterDelay:0.2];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.qrScanView.torchOn = NO;
    //关闭闪光灯
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode: AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }
}

-(UIAlertController *)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请到设置隐私中开启本程序相机权限" preferredStyle:UIAlertControllerStyleAlert];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    }
    return _alertController;
}


// 初始化扫描相关的属性
- (void)initScanComponents{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput  deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetMedium];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    // Preview
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = _qrScanView.frame;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                    AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code,
                                    ];
    // 设置扫描区域  CGRectMake((124)/kScreenHeight,((kScreenWidth-220)/2)/kScreenWidth,220/kScreenHeight,220/kScreenWidth)
    [_output setRectOfInterest:[MYScanView getScanRectWithPreView:_previewLayer style:_style]];
    // 先进行判断是否支持控制对焦。不开启自动对焦功能，很难识别二维码。
    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
}

//绘制扫描区域
- (void)drawScanView {
    if (!_qrScanView) {
        CGRect rect = CGRectMake(0, 0, self.view.width,self.view.height-kSafeAreaTopHeight);
        //设置扫码区域参数
        self.style = [[MYScanViewStyle alloc] init];
        _style.centerUpOffset = 44;
        _style.photoframeAngleStyle = MYScanViewPhotoframeAngleStyle_Inner;
        _style.photoframeLineW = 2.6;
        _style.photoframeAngleW = 20;
        _style.photoframeAngleH = 20;
        _style.isNeedShowRetangle = YES;
        _style.anmiationStyle = MYScanViewAnimationStyle_LineMove;
        _style.colorAngle = kMainGreenColor;
        //框框里面的线条图片
        UIImage *imgLine = [UIImage imageNamed:@"scanLine"];
        _style.animationImage = imgLine;
        self.qrScanView = [[MYScanView alloc] initWithFrame:rect style:_style];
        _qrScanView.delegate = self;
        [self.view addSubview:_qrScanView];
    }
    [_qrScanView startDeviceReadyingWithText:@"相机启动中"];
}



// 开始扫描
- (void)beginScan {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted)  {
        [_qrScanView stopDeviceReadying];
        [self presentViewController:self.alertController animated:YES completion:nil];
        return;
    }else{
        [self initScanComponents];

    }
    
    // Start
    [_session startRunning];
    [_qrScanView stopDeviceReadying];
    [_qrScanView startScanAnimation];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0)
    {
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSString *scanResult = metadataObject.stringValue;
        if (scanResult.length > 0) {
            if ([scanResult containsString:@"10000"]) {
                if (self.completionHandler) {
                    self.completionHandler(scanResult);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                WeakSelf
                [YTAlertUtil alertDualWithTitle:@"连程" message:@"请扫描有效的二维码!!!" style:UIAlertControllerStyleAlert cancelTitle:@"取消" cancelHandler:^(UIAlertAction *action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } defaultTitle:@"重新扫描" defaultHandler:^(UIAlertAction *action) {
                     [_session startRunning];
                } completion:nil];
               
            }
        }
    }
}
#pragma mark MYScanViewDelegate
//打开闪光灯关闭闪光灯
- (void)scanView:(MYScanView *)scanView didChangeTorchMode:(BOOL)torchOn{
    if (torchOn==YES) {
        NSError *error = nil;
        if ([_device hasTorch]) {
            BOOL locked = [_device lockForConfiguration:&error];
            if (locked) {
                _device.torchMode = AVCaptureTorchModeOn;
                [_device unlockForConfiguration];
            }
        }
    }else{
        if ([_device hasTorch]){
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
