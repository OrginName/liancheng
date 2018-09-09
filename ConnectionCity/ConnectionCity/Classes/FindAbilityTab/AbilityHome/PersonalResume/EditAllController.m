//
//  EditAllController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditAllController.h"

@interface EditAllController ()<UITextViewDelegate>


@end

@implementation EditAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    [self setUI];
}
//完成按钮点击
-(void)complete{
    if (self.textView_EditAll.text.length!=0) {
//        [YTAlertUtil showTempInfo:@"请输入要编辑的内容"];
        self.block(self.textView_EditAll.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    self.textView_EditAll.placeholder = @"请输入内容";
    self.textView_EditAll.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    if (self.receiveTxt.length!=0) {
        self.textView_EditAll.text = self.receiveTxt;
    }
}
 
@end
