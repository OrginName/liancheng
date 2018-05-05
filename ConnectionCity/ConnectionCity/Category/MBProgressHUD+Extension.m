//
//  MBProgressHUD+Extension.m
//  Dumbbell
//
//  Created by JYS on 16/1/24.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)
+ (void)showProgressHUDWithOnlyText:(NSString *)onlyText view:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = onlyText;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
