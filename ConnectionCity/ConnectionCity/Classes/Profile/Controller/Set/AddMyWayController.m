//
//  AddMyWayController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AddMyWayController.h"
#import "AccountView.h"
@interface AddMyWayController ()
@property (nonatomic,strong)AccountView *add;
@end

@implementation AddMyWayController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.add = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:nil options:nil][self.index_receive-1];
    self.add .frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview: self.add];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    
}
@end
