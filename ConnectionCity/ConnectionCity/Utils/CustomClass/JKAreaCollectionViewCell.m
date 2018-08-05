//
//  JKAreaCollectionViewCell.m
//  CIO领域demo
//
//  Created by 王冲 on 2017/11/14.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

#import "JKAreaCollectionViewCell.h"

@implementation JKAreaCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = YSColor(230, 230, 230).CGColor;
    }
    
    return self;
}

-(void)layout{
    
    /*
     *  名字的添加
     */
    int w = (int)self.width;
    _areaName = [[UILabel alloc]initWithFrame:CGRectMake(0,0,w, self.height)];
    _areaName.backgroundColor = [UIColor whiteColor];
    _areaName.font = [UIFont systemFontOfSize:13.f];
    _areaName.textColor = YSColor(143, 143, 143);
    _areaName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_areaName];
    
}

@end

