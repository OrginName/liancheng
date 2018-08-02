//
//  MyCircleController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/7/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyCircleController.h"
#import "FriendMyselfTab.h"
@interface MyCircleController ()
@property (nonatomic,strong)FriendMyselfTab * frendMyselfTab;
@end

@implementation MyCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setFlag_back:YES];
    [self.view addSubview:self.frendMyselfTab];
    self.navigationItem.title = @"服务圈";
}
//我的
-(FriendMyselfTab *)frendMyselfTab{
    if (!_frendMyselfTab) {
        _frendMyselfTab = [[FriendMyselfTab alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenHeight-64-44) style:UITableViewStyleGrouped withControll:self];
    }
    return _frendMyselfTab;
}
@end
