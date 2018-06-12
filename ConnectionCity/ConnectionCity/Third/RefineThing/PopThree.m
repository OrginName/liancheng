//
//  PopThree.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "PopThree.h"

@implementation PopThree
- (IBAction)BtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sendValue:)]) {
        [self.delegate sendValue:sender.tag];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
}
@end
