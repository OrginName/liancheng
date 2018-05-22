//
//  SendSwapController.m
//  ConnectionCity
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SendSwapController.h"
#import "PhotoSelect.h"
@interface SendSwapController ()

@end

@implementation SendSwapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    PhotoSelect * photo = [[PhotoSelect alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 200) withController:self];
    [self.view addSubview:photo];
}
@end
