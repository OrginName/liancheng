//
//  IdentityAuthorController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "IdentityAuthorController.h"
#import "TakePhoto.h"
#import "QiniuUploader.h"
#import "AllDicMo.h"

@interface IdentityAuthorController ()
@property (weak, nonatomic) IBOutlet UIButton *btn_select1;
@property (weak, nonatomic) IBOutlet UIButton *btn_select2;
@property (weak, nonatomic) IBOutlet UITextField *idtyypTF;
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UITextField *idTF;
@property (nonatomic, strong) NSString *frontImgStr;
@property (nonatomic, strong) NSString *backgroundImgStr;
@property (nonatomic, strong) AllContentMo *mo;

@end

@implementation IdentityAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"身份认证";
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
        if ([YSTools dx_isNullOrNilWithObject:self.mo]) {
            [YTAlertUtil showTempInfo:@"请选择证件类型"];
            return;
        }
        if ([YSTools dx_isNullOrNilWithObject:self.frontImgStr] || [YSTools dx_isNullOrNilWithObject:self.backgroundImgStr] || [YSTools dx_isNullOrNilWithObject:self.idTF.text]) {
            [YTAlertUtil showTempInfo:@"请将信息填写完整"];
            return;
        }
        if ([self.mo.value integerValue]==1) {
            if (![YSTools verifyIDCardNumber:self.idTF.text]) {
                [YTAlertUtil showTempInfo:@"请输入正确的证件号码"];
                return;
            }
        }else if([self.mo.value integerValue]==2) {
            if (![YSTools isValidatePassport:self.idTF.text]) {
                [YTAlertUtil showTempInfo:@"请输入正确的证件号码"];
                return;
            }
        }else if([self.mo.value integerValue]==3) {
            if (![YSTools isValidateHKMT:self.idTF.text]) {
                [YTAlertUtil showTempInfo:@"请输入正确的证件号码"];
                return;
            }
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
- (IBAction)idTypeSlectedBtnClick:(id)sender {
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    NSArray *contentArr = [arr[3] contentArr];
    NSMutableArray *title = [NSMutableArray array];
    for (int i=0; i < contentArr.count; i++) {
        AllContentMo * mo = contentArr[i];
        [title addObject:mo.description1];
        YTLog(@"%@",mo.description1);
        YTLog(@"%@",mo.value);
    }
    WeakSelf
    [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
        weakSelf.mo = contentArr[idx];
        weakSelf.idtyypTF.text = weakSelf.mo.description1;
    } cancelTitle:@"取消" cancelHandler:nil completion:nil];
}
- (void)requestData {
    NSDictionary *dic = @{@"certNo": _idTF.text,@"image":[NSString stringWithFormat:@"%@;%@",self.frontImgStr,self.backgroundImgStr],@"type":_mo.value};
    WeakSelf
    [YSNetworkTool POST:v1MyAuthUseridentityAuthCreate params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}
@end
