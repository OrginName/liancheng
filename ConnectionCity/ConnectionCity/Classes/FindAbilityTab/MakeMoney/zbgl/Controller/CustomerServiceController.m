//
//  CustomerServiceController.m
//  YTParkingSystem
//
//  Created by YanShuang Jiang on 2018/5/24.
//  Copyright © 2018年 YT. All rights reserved.
//

#import "CustomerServiceController.h"
#import "YTAdviceInputView.h"
#import "YTPlaceholderTextView.h"

@interface CustomerServiceController ()
@property (weak, nonatomic) IBOutlet UIView *adviceBg;
@property (nonatomic, strong) YTAdviceInputView *adviceView;
@property (nonatomic, strong) UIButton *lastBtn;

@end

@implementation CustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setupNav {
    self.navigationItem.title = @"客服";
}
- (void)setupView {
    self.view.backgroundColor = kCommonBGColor;
    [self.adviceBg addSubview:self.adviceView];
}
#pragma mark - setter and getter
- (YTAdviceInputView *)adviceView {
    if (_adviceView == nil) {
        _adviceView = [[YTAdviceInputView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, _adviceBg.height)];
        _adviceView.count = 300;
        _adviceView.layer.masksToBounds = YES;
        _adviceView.layer.cornerRadius = 5;
        _adviceView.layer.borderWidth = 1;
        _adviceView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _adviceView.textView.placeholder = @"请输入您的反馈意见(300字以内)";
    }
    return _adviceView;
}
#pragma mark - 点击事件
- (IBAction)btnClick:(id)sender {
    UIButton *currentBtn = (UIButton *)sender;
    if (currentBtn == _lastBtn) {
        return;
    }
    _lastBtn.selected = NO;
    currentBtn.selected = YES;
    _lastBtn = currentBtn;
}
- (IBAction)commitBtnClick:(id)sender {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
