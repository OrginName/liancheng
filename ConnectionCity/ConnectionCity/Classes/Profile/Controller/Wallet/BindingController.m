//
//  BindingController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//   绑定账户

#import "BindingController.h"
#import "AllDicMo.h"

@interface BindingController ()
@property (weak, nonatomic) IBOutlet UITextField *txt_people;
@property (weak, nonatomic) IBOutlet UITextField *txt_type;
@property (weak, nonatomic) IBOutlet UITextField *txt_Account;
@property (weak, nonatomic) IBOutlet UILabel *lab_Phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_YZM;
@property (weak, nonatomic) IBOutlet UIButton *btn_YZM;

@end

@implementation BindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"绑定账号";
}
- (IBAction)accountTypeBtnClick:(id)sender {
    NSMutableArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    NSArray *contentArr = [arr[26] contentArr];
    NSMutableArray *title = [NSMutableArray array];
    for (int i=0; i < contentArr.count; i++) {
        AllContentMo * mo = contentArr[i];
        [title addObject:mo.description1];
        YTLog(@"%@",mo.description1);
        YTLog(@"%@",mo.value);
    }
    WeakSelf
    [YTAlertUtil alertMultiWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet multiTitles:title multiHandler:^(UIAlertAction *action, NSArray *titles, NSUInteger idx) {
        AllContentMo * mo = contentArr[idx];
        weakSelf.txt_type.text = mo.value;
    } cancelTitle:@"取消" cancelHandler:nil completion:nil];
}
- (IBAction)getVerificationCodeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (![YSTools isRightPhoneNumberFormat:_lab_Phone.text]) {
        [YTAlertUtil showTempInfo:@"请填写正确的手机号码"];
        return;
    }
    //WeakSelf
    [YSNetworkTool POST:smsVerificationCode params:@{@"mobile": _lab_Phone.text} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([YSNetworkTool isSuccessWithResp:responseObject]) {
            [YSTools DaojiShi:btn];
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }else{
            [YTAlertUtil showTempInfo:responseObject[kMessage]];
        }
    } failure:nil];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if([YSTools dx_isNullOrNilWithObject:_txt_people.text] || [YSTools dx_isNullOrNilWithObject:_txt_Account.text]||[YSTools dx_isNullOrNilWithObject:_txt_type.text]||[YSTools dx_isNullOrNilWithObject:_txt_YZM.text]){
        [YTAlertUtil showTempInfo:@"请将信息填写完整"];
        return;
    }
    NSDictionary *dic = @{
                          @"accountName": _txt_people.text,
                          @"accountNumber": _txt_Account.text,
                          @"accountType": _txt_type.text,
                          @"bankName": @"",
                          @"code": _txt_YZM.text,
                          };
    WeakSelf
    [YSNetworkTool POST:v1UserWalletWithdrawAccountAdd params:dic showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [YTAlertUtil alertSingleWithTitle:@"提示" message:responseObject[kMessage] defaultTitle:@"确定" defaultHandler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } completion:nil];
    } failure:nil];
}

@end
