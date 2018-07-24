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

@interface AddMyWayController ()<AccountViewDelegate>
@property (nonatomic,strong)AccountView *add;
@end
@implementation AddMyWayController
-(void)viewDidLayoutSubviews{
    self.add = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:nil options:nil][self.index_receive-1];
    self.add.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview: self.add];
    self.add.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark -----AccountViewDelegate------
- (void)selectedItemButton:(UserMo *)user{
    PersonalBasicDataController * person = [PersonalBasicDataController new];
    person.flagStr = @"BLACKLIST";
    person.connectionMo = user;
    [self.navigationController pushViewController:person animated:YES];
}
@end
