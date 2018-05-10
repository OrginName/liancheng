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
        self.layer.borderWidth = 1.0;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.layer.borderColor = [UIColor hexColorWithString:@"#f49930"].CGColor;
        [self setTitleColor:[UIColor hexColorWithString:@"#f49930"] forState:UIControlStateNormal];
    }else{
        self.layer.borderColor = YSColor(246, 246, 246).CGColor;
        [self setTitleColor:[UIColor hexColorWithString:@"#282828"] forState:UIControlStateNormal];
    }
}

@end
