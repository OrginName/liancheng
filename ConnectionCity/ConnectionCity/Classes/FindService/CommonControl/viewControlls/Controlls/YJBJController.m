//
//  YJBJController.m
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "YJBJController.h"
#import "YJBJDesController.h"
#import "AddNewContact1Controller.h"
#import "PersonNet.h"
#import "CustomMap.h"
@interface YJBJController ()
@property (weak, nonatomic) IBOutlet UIView *view_Tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_ljtj;

@end

@implementation YJBJController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self setUI1];
}
-(void)MessageClick{
    YJBJDesController  * des = [YJBJDesController new];
    des.title = @"一键报警功能说明";
    [self.navigationController pushViewController:des animated:YES];
}
-(void)setUI1{
    CustomMap * map = [[CustomMap alloc] initWithFrame:CGRectZero];
    map.hidden = YES;
    [self.view addSubview:map];
}
/**
 一键报警说明

 @param sender 事件
 */
- (IBAction)btn_des:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            AddNewContact1Controller * add = [AddNewContact1Controller new];
            add.title = @"添加紧急联系人";
            [self.navigationController pushViewController:add animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"%@",[KUserDefults objectForKey:KUserAddress]);
            [PersonNet requstContactSMS:@{@"address":[KUserDefults objectForKey:KUserAddress]?[KUserDefults objectForKey:KUserAddress]:@""} withDic:^(NSDictionary *successDicValue) {
                [YSTools DaDianHua:@"110"];
            } FailDicBlock:nil];
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(MessageClick) image:@"" title:@"功能说明" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
@end
