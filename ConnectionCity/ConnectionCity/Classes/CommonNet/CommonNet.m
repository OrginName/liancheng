//
//  CommonNet.m
//  ConnectionCity
//
//  Created by umbrella on 2018/10/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CommonNet.h"

@implementation CommonNet
/**
 检查版本更新
 */
+(void)CheckVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [YSNetworkTool POST:v1AppVersion params:@{@"type":@"IOS"} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * version_New = responseObject[@"data"][@"version"];
        if ([version_New isEqualToString:appCurVersion]) {
            return [YTAlertUtil showTempInfo:@"已是最新版本"];
        }
        if ([version_New compare:appCurVersion options:NSNumericSearch] == NSOrderedDescending){
            [YTAlertUtil alertSingleWithTitle:@"连程" message:KString(@"发现新版本V %@", version_New) defaultTitle:@"去更新" defaultHandler:^(UIAlertAction *action) {
                NSString *str = v1CheckVersionUrl; //更换id即可
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } completion:nil];
        } 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
