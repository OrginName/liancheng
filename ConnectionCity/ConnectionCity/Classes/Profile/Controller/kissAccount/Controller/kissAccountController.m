//
//  kissAccountController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "kissAccountController.h"
#import "MeView.h"
#import "OtherView.h"
#import "AddKissController.h"
@interface kissAccountController ()<OtherViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *tabBgV;
@property (weak, nonatomic) IBOutlet UIButton *meBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (nonatomic, strong) MeView *meV;
@property (nonatomic, strong) OtherView *otherV;
@property (nonatomic, strong) UIButton *lastBtn;
@end

@implementation kissAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = kCommonBGColor;
    self.meV.frame = CGRectMake(0, 0, _tabBgV.width, _tabBgV.height);
    self.otherV.frame = CGRectMake(0, 0, _tabBgV.width, _tabBgV.height);
}
- (void)setUI {
    self.navigationItem.title = @"亲密账户";
    self.lastBtn = self.meBtn;
    [_tabBgV addSubview:self.meV];
    [_tabBgV addSubview:self.otherV];
    self.meV.hidden = NO;
    self.otherV.hidden = YES;
}
//wo
-(MeView *)meV{
    if (!_meV) {
        _meV = [[MeView alloc] initWithFrame:CGRectMake(0, 0, _tabBgV.width, _tabBgV.height) viewController:self];
    }
    return _meV;
}
//ta
-(OtherView *)otherV{
    if (!_otherV) {
        _otherV = [[OtherView alloc] initWithFrame:CGRectMake(0, 0, _tabBgV.width, _tabBgV.height) viewController:self];
        _otherV.delegate = self;
    }
    return _otherV;
}

- (IBAction)switchBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (_lastBtn == btn) {
        return;
    }
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _lastBtn = btn;
    if (btn.tag==100) {
        self.meV.hidden = NO;
        self.otherV.hidden = YES;
    } else if (btn.tag==101) {
        self.meV.hidden = YES;
        self.otherV.hidden = NO;
    }
}
#pragma mark - OtherViewDelegate
- (void)otherView:(OtherView *)view addBtn:(UIButton *)btn {
    AddKissController * kiss = [AddKissController new];
    kiss.title = @"添加亲密账户";
    [self.navigationController pushViewController:kiss animated:YES];
}
@end
