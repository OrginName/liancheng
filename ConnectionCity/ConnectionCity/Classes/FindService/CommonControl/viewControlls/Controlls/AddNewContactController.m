//
//  AddNewContactController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddNewContactController.h"
#import "PersonNet.h"
@interface AddNewContactController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_Name;

@end

@implementation AddNewContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.txt_Name.text = [self.dicReceive[@"name"] description];
    self.txt_phone.text = [self.dicReceive[@"mobile"] description];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(UpdateClick) image:@"" title:@"更新" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)UpdateClick{
    WeakSelf
    NSDictionary * dic = @{
                           @"id": [self.dicReceive[@"id"] description],
                           @"mobile": self.txt_phone.text,
                           @"name": self.txt_Name.text
                           };
    [PersonNet requstUpdateContact:dic withDic:^(NSDictionary *successDicValue) {
        if (weakSelf.blcok) {
            weakSelf.blcok();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } FailDicBlock:nil];
}
- (IBAction)deleteClick:(UIButton *)sender {
     UIAlertView *WXinstall=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除该紧急联系人吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//一般在if判断中加入
    [WXinstall show];
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WeakSelf
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"取消"]) {
        NSLog(@"你点击了取消");
    }else if ([btnTitle isEqualToString:@"确定"] ) {
        [PersonNet requstDeleContact:@{@"id":[self.dicReceive[@"id"] description]} withDic:^(NSDictionary *successDicValue) {
            if (weakSelf.blcok) {
                weakSelf.blcok();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } FailDicBlock:nil];
    }//https在iTunes中找，这里的事件是前往手机端App store下载微信
}
@end
