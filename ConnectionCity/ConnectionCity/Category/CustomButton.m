//
//  CustomButton.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/10.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CustomButton.h"
#import "YSConstString.h"
@implementation CustomButton
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self setBackgroundColor:[UIColor hexColorWithString:@"#f49930"]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self setBackgroundColor:[UIColor hexColorWithString:@"#f2f2f2"]];
        [self setTitleColor:[UIColor hexColorWithString:@"#282828"] forState:UIControlStateNormal];
    }
}

@end
