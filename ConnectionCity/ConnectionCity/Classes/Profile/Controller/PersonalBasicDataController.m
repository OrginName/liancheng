//
//  PersonalBasicDataController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/7/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PersonalBasicDataController.h"
#import "EditAllController.h"

@interface PersonalBasicDataController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *lcNumLab;
@property (weak, nonatomic) IBOutlet UILabel *beiZhuLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;

@end

@implementation PersonalBasicDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setUI {
    self.navigationItem.title = @"基础资料";
    _headImage.layer.cornerRadius = 27;
    _headImage.clipsToBounds = YES;
}
#pragma mark - 点击事件
- (IBAction)sendMessageBtnClick:(id)sender {
    
}
- (IBAction)beizhuBtnClick:(id)sender {
    EditAllController * edit = [EditAllController new];
    WeakSelf
    edit.block = ^(NSString * str){
        YTLog(@"%@",str);
    };
    [self.navigationController pushViewController:edit animated:YES];
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
