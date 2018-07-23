//
//  SendSwapController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendSwapController.h"
#import "PhotoSelect.h"
#import "EditAllController.h"
@interface SendSwapController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
}
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;
@property (weak, nonatomic) IBOutlet UIView *view_PhotoSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layou_Photo;
@property (weak, nonatomic) IBOutlet CustomtextView *textview_MS;
@property (weak, nonatomic) IBOutlet UITextField *txt_headTitle;

@property (nonatomic,strong)PhotoSelect * photo;
@end

@implementation SendSwapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma mark --- 发布提交Upload---
-(void)Upload{
    [YTAlertUtil showTempInfo:@"提交"];
}
//所在地区 互换标题  互换板块
- (IBAction)btn_Click:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag==3) {
        EditAllController * edit = [EditAllController new];
        edit.receiveTxt = self.txt_headTitle.text;
        edit.block = ^(NSString * str){
            self.txt_headTitle.text = str;
        };
    }
}
-(void)setUI{
    self.navigationItem.title = @"发布互换信息";
    itemHeigth = (self.view_PhotoSelect.width - 50) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, self.view_PhotoSelect.width, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor clearColor];
    self.layou_Photo.constant = itemHeigth+10;
    self.photo.PhotoDelegate = self;
    [self.view_PhotoSelect addSubview:self.photo];
    self.textview_MS.placeholder = @"   请输入描述";
    self.textview_MS.placeholderColor = YSColor(213, 213, 213);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(Upload) image:@"" title:@"提交" EdgeInsets:UIEdgeInsetsZero];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layou_Photo.constant  = itemHeigth*2;
    }
}
@end
