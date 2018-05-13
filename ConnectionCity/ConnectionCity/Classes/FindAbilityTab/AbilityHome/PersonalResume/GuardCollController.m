//
//  GuardEduAndCollController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "GuardCollController.h"
#import "MyDatePicker.h"
#import "EditAllController.h"
@interface GuardCollController ()<UITextViewDelegate,MyDatePickerDelegate>
{
    NSInteger  currentTag;
}
@property (nonatomic,strong) MyDatePicker * myDatePick;
@property (weak, nonatomic) IBOutlet CustomtextView *textView_Indro;
@property (weak, nonatomic) IBOutlet UIButton *bttn_Save;
@property (weak, nonatomic) IBOutlet UITextField *txt_Company;
@property (weak, nonatomic) IBOutlet UITextField *txt_pro;
@property (weak, nonatomic) IBOutlet UITextField *end_Time;
@property (weak, nonatomic) IBOutlet UITextField *start_time;
@end

@implementation GuardCollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//完成按钮点击
-(void)complete{
    [self btn_Save:nil];
}
- (IBAction)btn_Save:(UIButton *)sender {
    if (self.txt_Company.text.length==0||self.txt_pro.text.length==0||self.textView_Indro.text.length==0||self.start_time.text.length==02||self.end_Time.text.length==0) {
        [YTAlertUtil showTempInfo:@"请查看是否输入完整"];
        return;
    }
    ResumeMo * mo = [[ResumeMo alloc] init];
    mo.collAndcompany = self.txt_Company.text;
    mo.proAndPro = self.txt_pro.text;
    mo.XLAndIntro = self.textView_Indro.text;
    mo.satrtTime = self.start_time.text;
    mo.endTime = self.end_Time.text;
    self.block(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btn_Click:(UIButton *)sender {
    if (sender.tag<3) {
        NSArray * arr = @[self.txt_Company,self.txt_pro];
        EditAllController * edit = [EditAllController new];
        edit.block = ^(NSString * str){
            UITextField * text = (UITextField *)arr[sender.tag-1];
            text.text = str;
        };
        [self.navigationController pushViewController:edit animated:YES];
    }else{
        currentTag = sender.tag;
        [self.myDatePick animateShow];
    }
}
-(void)setUI{
    self.textView_Indro.placeholder = @"请输入工作描述";
    self.textView_Indro.placeholderColor = [UIColor hexColorWithString:@"#bbbbbb"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self initDate];
    
}
#pragma mark ---myDatePickerDelegate-----
- (void)myDatePickerWithDateStr:(NSString *)dateStr{
    UITextField * text = (UITextField *)[self.view viewWithTag:currentTag+5];
    text.text = dateStr;
}
//创建日期插件
-(void)initDate{
    self.myDatePick = [[MyDatePicker alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 250)];
    self.myDatePick.delegate  = self;
    [self.view addSubview:self.myDatePick];
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
