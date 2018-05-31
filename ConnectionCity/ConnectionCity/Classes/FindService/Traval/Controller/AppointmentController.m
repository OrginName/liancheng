//
//  AppointmentController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AppointmentController.h"

@interface AppointmentController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_title1;
@property (weak, nonatomic) IBOutlet UILabel *lab_title2;
@property (weak, nonatomic) IBOutlet UILabel *lab_title3;

@end

@implementation AppointmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"章鱼小丸子";
    [self setUI];
}
-(void)setUI{
    if ([self.str isEqualToString:@"YD"]) {
        self.lab_title1.text = @"服务价格";
        self.lab_title2.text = @"服务时间";
        self.lab_title3.text = @"服务地点";
    }
}
@end
