//
//  SwapHeadView.m
//  ConnectionCity
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SwapHeadView.h"

@implementation SwapHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)btn_Click:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(swapHeadClick:)]) {
        [self.delegate swapHeadClick:sender.tag];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
