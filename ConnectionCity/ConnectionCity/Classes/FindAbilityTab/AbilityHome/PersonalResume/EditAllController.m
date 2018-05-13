//
//  EditAllController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditAllController.h"

@interface EditAllController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet CustomtextView *textView_EditAll;


@end

@implementation EditAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//完成按钮点击
-(void)complete{
    
}
-(void)setUI{
    self.textView_EditAll.placeholder = @"请输入内容";
    self.textView_EditAll.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
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
    self.textView_EditAll.attributedText = [[NSAttributedString alloc] initWithString:self.textView_EditAll.text attributes:attributes];
}
@end
