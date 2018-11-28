//
//  YJBJController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "YJBJController.h"
#import "YJBJDesController.h"
#import "AddNewContactController.h"
@interface YJBJController ()
@property (weak, nonatomic) IBOutlet UIView *view_Tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_ljtj;

@end

@implementation YJBJController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

/**
 一键报警说明

 @param sender 事件
 */
- (IBAction)btn_des:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            YJBJDesController  * des = [YJBJDesController new];
            des.title = @"一键报警功能说明";
            [self.navigationController pushViewController:des animated:YES];
        }
            break;
        case 2:
        {
            AddNewContactController * add = [AddNewContactController new];
            add.title = @"添加紧急联系人";
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 3:
        {
            [YTAlertUtil showTempInfo:@"呼叫110"];
        }
            break;
        default:
            break;
    }
    
}
-(void)setUI{
    self.view_Tip.layer.cornerRadius = 10;
    self.view_Tip.layer.masksToBounds = NO;
    self.view_Tip.layer.shadowColor = YSColor(225, 226, 227).CGColor;
    self.view_Tip.layer.shadowOffset = CGSizeMake(5, 5);
    self.view_Tip.layer.shadowOpacity = .5;
    self.view_Tip.layer.shadowRadius = 10;
    self.btn_ljtj.layer.borderColor = YSColor(214, 214, 216).CGColor;
    self.btn_ljtj.layer.borderWidth = 1;
}
@end
