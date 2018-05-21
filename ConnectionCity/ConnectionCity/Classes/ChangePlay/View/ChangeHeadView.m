    //
//  ChangeHeadView.m
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ChangeHeadView.h"

@implementation ChangeHeadView
-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, -289, kScreenWidth-20, 289);
}
- (IBAction)btn_Click:(UIButton *)sender {
    self.block(sender.tag);
}
@end
