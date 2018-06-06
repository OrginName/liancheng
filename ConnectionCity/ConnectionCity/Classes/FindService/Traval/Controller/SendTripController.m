//
//  SendTripController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendTripController.h"
#import "PhotoSelect.h"
@interface SendTripController ()<PhotoSelectDelegate>
{
    CGFloat itemHeigth;
    UIButton * _tmpBtn;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_select;
@property (nonatomic,strong)PhotoSelect * photo;
@property (weak, nonatomic) IBOutlet UIView *view_Select;
@end

@implementation SendTripController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
//完成
-(void)complete{
    [YTAlertUtil showTempInfo:@"完成"];
}
- (IBAction)btn_priceSelect:(UIButton *)sender {
    if (sender.tag!=3) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:1];
        btn.selected = NO;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    if (_tmpBtn !=nil &&_tmpBtn == sender){
        sender.selected = YES;
    } else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}
-(void)setUI{
    self.navigationItem.title = @"发布陪游";
    itemHeigth = (kScreenWidth-70) / 4+10;
    self.photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, itemHeigth) withController:self];
    self.photo.backgroundColor = [UIColor whiteColor];
    self.photo.PhotoDelegate = self;
    self.layout_select.constant = itemHeigth;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complete) image:@"" title:@"完成" EdgeInsets:UIEdgeInsetsZero];
    [self.view_Select addSubview:self.photo];
}
#pragma mark ----PhotoSelectDelegate-----
-(void)selectImageArr:(NSArray *)imageArr{
    NSLog(@"%lu",(unsigned long)imageArr.count);
    if (imageArr.count>4) {
        self.photo.height=self.layout_select.constant= itemHeigth*2; 
    }
}
@end
