//
//  GuardEduAndCollController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "GuardEduController.h"

@interface GuardEduController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet CustomtextView *textView_Indro;
@end

@implementation GuardEduController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//完成按钮点击
-(void)complete{
    [YTAlertUtil showTempInfo:@"别点了"];
}
-(void)setUI{
    self.textView_Indro.placeholder = @"请输入工作描述";
    self.textView_Indro.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self initSettitle];
}
-(void)initSettitle{
    
}
-(void)textViewDidChange:(UITextView *)textView{
    //首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;    //行间距
    //    paragraphStyle.maximumLineHeight = 60;   /**最大行高*/
    paragraphStyle.firstLineHeadIndent = 20.f;    /**首行缩进宽度*/
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 ,NSForegroundColorAttributeName:[UIColor hexColorWithString:@"#bbbbbb"]};
    self.textView_Indro.attributedText = [[NSAttributedString alloc] initWithString:self.textView_Indro.text attributes:attributes];
}
@end

