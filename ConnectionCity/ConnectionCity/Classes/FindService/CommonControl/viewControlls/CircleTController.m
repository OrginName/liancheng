//
//  CircleTController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CircleTController.h"

@interface CircleTController ()
{
    NSInteger _CurrentTag;
    NSString * _cityCode;
}
@property (nonatomic,strong)UIImageView * headImage;
@property (nonatomic,strong) NSMutableArray *momentList;
@property (nonatomic,assign) NSInteger page;
@end

@implementation CircleTController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initTestInfo];
    _page=1;
//    [self setComment];
}
#pragma mark - 测试数据
- (void)initTestInfo
{
    WeakSelf
    self.tab_Bottom.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
//        [weakSelf loadDataFriendList:_cityCode];
    }];
    self.tab_Bottom.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadDataFriendList:_cityCode];
    }];
    
}
@end
