//
//  BaseViewController.m
//  Dumbbell
//
//  Created by JYS on 16/1/19.
//  Copyright © 2016年 JYS. All rights reserved.
//

#import "BaseViewController.h"
//#import "UICKeyChainStore.h"
#import <AdSupport/AdSupport.h>

@interface BaseViewController ()
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView.hidden = YES;
    self.view.backgroundColor = kCommonBGColor;
    
    // Do any additional setup after loading the view.
}
//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//隐藏导航条下方黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
//取消键盘响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//获取文件路径
- (NSString *)getFilePathWithName:(NSString *)name {
    //首先取出Documents路径 然后在路径后追加文件名 此方法会自动添加斜杠
    return [[self getDocumentsPath] stringByAppendingPathComponent:name];
}
///获取Documents路径
- (NSString *)getDocumentsPath {
    NSString *documnetsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *userPath = [documnetsPath stringByAppendingPathComponent:@"UserNameJYS"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userPath;
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

