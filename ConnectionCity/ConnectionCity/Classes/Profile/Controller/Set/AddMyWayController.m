//
//  AddMyWayController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddMyWayController.h"
#import "AccountView.h"
#import "PersonalBasicDataController.h"
#import <RongIMLib/RongIMLib.h>
@interface AddMyWayController ()<AccountViewDelegate>
@property (nonatomic,strong)AccountView *add;
@end
@implementation AddMyWayController
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.add = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:nil options:nil][self.index_receive-1];
    self.add.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview: self.add];
    self.add.delegate = self;
    self.add.dic = self.dic;
    WeakSelf
    [[RCIMClient sharedRCIMClient] getNotificationQuietHours:^(NSString *startTime, int spansMin) {
        NSLog(@"%@---%d",startTime,spansMin);
        if (spansMin<=0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知主线程刷新 神马的
                [weakSelf.add.switch_Three setOn:NO];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知主线程刷新 神马的
                [weakSelf.add.switch_Three setOn:YES];
            });
        }
    } error:^(RCErrorCode status) {
        NSLog(@"%ld",(long)status);
    }];
}
#pragma mark -----AccountViewDelegate------
- (void)selectedItemButton:(UserMo *)user{
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.flagStr = @"BLACKLIST";
    person.connectionMo = user;
    [self.navigationController pushViewController:person animated:YES];
}
@end
