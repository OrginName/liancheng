//
//  TakePhoto.m
//  TakePhoto
//
//  Created by JYS on 16/2/15.
//  Copyright © 2016年 JYS. All rights reserved.
//

#define AppRootView ([[[[[UIApplication sharedApplication]delegate]window]rootViewController]view])
#define AppRootViewController ([[[[UIApplication sharedApplication]delegate]window]rootViewController])

#import "TakePhoto.h"

@implementation TakePhoto

+ (TakePhoto *)sharedPhoto {
    static TakePhoto *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc]init];
    });
    return sharedModel;
}

- (void)sharePicture:(sendPictureBlock)block {
    
    self.pictureBlock = block;
    UIAlertController *sheetViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *imagePickrerController = [[UIImagePickerController alloc]init];
    imagePickrerController.delegate = self;
    imagePickrerController.allowsEditing = YES;
    
    [sheetViewController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickrerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [AppRootViewController presentViewController:imagePickrerController animated:YES completion:NULL];
    }]];
    [sheetViewController addAction:[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickrerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [AppRootViewController presentViewController:imagePickrerController animated:YES completion:NULL];
    }]];
    [sheetViewController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [AppRootViewController presentViewController:sheetViewController animated:YES completion:nil];
}

#pragma mark -- 
#pragma mark imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.pictureBlock(image);
}

@end











































