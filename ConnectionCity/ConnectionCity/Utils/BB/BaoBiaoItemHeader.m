//
//  BaoBiaoItemHeader.m
//  NTS-S
//
//  Created by zeng on 16/8/9.
//  Copyright © 2016年 zeng. All rights reserved.
//

#import "BaoBiaoItemHeader.h"

@interface BaoBiaoItemHeader()

@end

@implementation BaoBiaoItemHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = YSColor(247, 247, 247).CGColor;
    self.layer.borderWidth = 0.5f;
    self.mLabel.textColor = YSColor(118, 118, 118);
}

//设置数据
-(void)setMessage:(NSString *)message{
    self.mLabel.text = [NSString stringWithFormat:@"%@",message];
}


- (IBAction)onClick:(id)sender {
    
}

@end
