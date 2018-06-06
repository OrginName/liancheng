//
//  SkillCertificationController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SkillCertificationController.h"
#import "TakePhoto.h"
@interface SkillCertificationController ()
@property (weak, nonatomic) IBOutlet UIView *view_Bottom;

@end

@implementation SkillCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"技能认证";
}
- (IBAction)PhotoSelect:(UIButton *)sender {
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag+3];
    [[TakePhoto sharedPhoto] sharePicture:^(UIImage *image) {
        [sender setBackgroundImage:image forState:UIControlStateNormal];
        btn.hidden = NO;
    }];
}
- (IBAction)DeleteClick:(UIButton *)sender {
    if (sender.tag == 4) {
        [YTAlertUtil showTempInfo:@"提交认证"];
        return;
    }
    UIButton * btn = (UIButton *)[self.view_Bottom viewWithTag:sender.tag-3];
    [btn setBackgroundImage:[UIImage imageNamed:@"jia200-5"] forState:UIControlStateNormal];
    sender.hidden = YES;
}
@end
