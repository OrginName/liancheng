//
//  SkillCertificationController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SkillCertificationController.h"
#import "TakePhoto.h"
#import "QiniuUploader.h"

@interface SkillCertificationController ()
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic, strong) NSString *frontImgStr;
@property (nonatomic, strong) NSString *backgroundImgStr;

@end

@implementation SkillCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"技能认证";
}
- (IBAction)PhotoSelect:(UIButton *)sender {
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag+3];
    WeakSelf
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [sender setBackgroundImage:image forState:UIControlStateNormal];
        btn.hidden = NO;
        [YTAlertUtil showHUDWithTitle:nil];
        [[QiniuUploader defaultUploader] uploadImageToQNFilePath:image withBlock:^(NSDictionary *url) {
            [YTAlertUtil hideHUD];
            if (btn.tag==5) {
                weakSelf.frontImgStr = [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
            }
            if (btn.tag==6){
                weakSelf.backgroundImgStr = [NSString stringWithFormat:@"%@%@",QINIUURL,url[@"hash"]];
            }
        }];
    }];
}
- (IBAction)DeleteClick:(UIButton *)sender {
    if (sender.tag == 4) {
        if ([YSTools dx_isNullOrNilWithObject:self.frontImgStr] || [YSTools dx_isNullOrNilWithObject:self.backgroundImgStr] || [YSTools dx_isNullOrNilWithObject:self.nameTF.text]||[YSTools dx_isNullOrNilWithObject:self.numberTF.text]) {
            [YTAlertUtil showTempInfo:@"请将信息填写完整"];
            return;
        }
        [self requestData];
        return;
    }
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag-3];
    [btn setBackgroundImage:[UIImage imageNamed:@"jia200-5"] forState:UIControlStateNormal];
    sender.hidden = YES;
    if (sender.tag==5) {
        self.frontImgStr = nil;
    }
    if (sender.tag==6) {
        self.backgroundImgStr = nil;
    }
}
- (void)requestData {
    NSDictionary *dic = @{@"certName": _nameTF.text,@"certNo": _numberTF.text,@"image":[NSString stringWithFormat:@"%@;%@",self.frontImgStr,self.backgroundImgStr]};
    WeakSelf
    [YSNetworkTool POST:v1MyAuthUserskillAuthCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
@end
