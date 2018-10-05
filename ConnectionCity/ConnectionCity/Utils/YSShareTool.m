//
//  YSShareTool.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "YSShareTool.h"

@implementation YSShareTool
+(void)share {
    //1、创建分享参数
    NSArray* imageArray = @[@"https://yikepic-1256971091.cos.ap-beijing.myqcloud.com/1530501511306.jpg"];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"连你所需连你所能连你远大前程"
                                         images:[UIImage imageNamed:@"AppIcon"]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/share/invite/index?uid=%@",baseUrl,kAccount.userId]]
                                          title:@"连程"
                                           type:SSDKContentTypeAuto];
        
        //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

+ (void)share:(SSDKPlatformType)type {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    [shareParams SSDKSetupShareParamsByText:@"连你所需连你所能连你远大前程" images:[UIImage imageNamed:@"AppIcon"] url:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.lc.test.cn-apps.com/share/invite/index?uid=%@",kAccount.userId]] title:@"连程" type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData,SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                if (type == SSDKPlatformTypeSinaWeibo) {
                    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                }
                [UIAlertView showAlertViewWithTitle:@"提示" message:@"分享成功" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(long buttonIndex) {
                    
                } onCancel:^{
                    
                }];
                break;
            }
            case SSDKResponseStateFail:
            {
                [UIAlertView showAlertViewWithTitle:@"提示" message:@"分享失败" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(long buttonIndex) {
                    
                } onCancel:^{
                    
                }];
                break;
            }
            default:
                break;
        }
    }];
}

@end
