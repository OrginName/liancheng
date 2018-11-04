//
//  EditMenuController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditMenuController.h"
#import "ChannelView.h"
#import "HomeNet.h"
#import "MenuMo.h"
@interface EditMenuController ()
@property (nonatomic, strong) ChannelView *channelView;
@property (nonatomic,strong) NSMutableArray * MyArr;
@property (nonatomic ,strong) NSMutableArray * allMenuArr;//所有的菜单
@end

@implementation EditMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    [self initData];
    
}

-(void)initData{
    self.MyArr = [NSMutableArray array];
    self.allMenuArr = [NSMutableArray array]; 
    WeakSelf
    [HomeNet loadMyMeu:^(NSMutableArray *successArrValue) {
        weakSelf.MyArr = successArrValue;
        [HomeNet loadAllMeu:^(NSMutableArray *successArrValue) {
            for (MenuMo * mo in weakSelf.MyArr) {
                if ([successArrValue containsObject:mo]) {
                    [successArrValue removeObject:mo];
                }
            }
            weakSelf.allMenuArr = successArrValue;
            [weakSelf setUI];
        }];
    }];
}
-(void)setUI{
    self.channelView = [[ChannelView alloc]initWithFrame:CGRectMake(0,20, kScreenWidth, kScreenHeight-20)];
    self.channelView.backgroundColor = YSColor(244, 244, 244);
    //添加数据
    self.channelView.upBtnDataArr = [self.MyArr copy];
    self.channelView.belowBtnDataArr = [self.allMenuArr copy];
    //每行按钮个数
    self.channelView.btnNumber = 4;
    //允许第一个按钮参与编辑
    self.channelView.IS_compileFirstBtn = YES;
    //设置按钮字体Font
    self.channelView.btnTextFont = 13.0f;
    //获取数据Block
    WeakSelf
    self.channelView.dataBlock = ^(NSMutableArray *dataArr) {
        for (NSString *upBtnText in dataArr) {
            NSLog(@"%@",upBtnText);
        }
    };
    self.channelView.closeBlock = ^(UIButton *btn) {
        [weakSelf Close];
    };
    [self.view addSubview:self.channelView];
}
-(void)Close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //关闭自适应
    if (@available(iOS 11.0, *)) {
        self.channelView.ScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
@end
