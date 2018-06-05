//
//  CardAuthorController.m
//  ConnectionCity
//
//  Created by qt on 2018/6/5.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CardAuthorController.h"

@interface CardAuthorController ()
@property (weak, nonatomic) IBOutlet UILabel *lab_tips;

@end

@implementation CardAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.navigationItem.title = @"手机号认证";
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:self.lab_tips.text];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor],};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(10,4)];
    [firstPart setAttributes:firstAttributes range:NSMakeRange(15,4)];
    self.lab_tips.attributedText = firstPart;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labClick:)];
    [self.lab_tips addGestureRecognizer:tap];
}
-(void)labClick:(UIGestureRecognizer *)tap{
    
}
@end
