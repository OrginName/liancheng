//
//  JKAreaTableViewCell.m
//  CIO领域demo
//
//  Created by 王冲 on 2017/11/14.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

#import "JKAreaTableViewCell.h"

@implementation JKAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _view_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 2)];
        _view_top.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_view_top];
        
        
        _nameText = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 100, 37)];
        _nameText.backgroundColor = [UIColor clearColor];
        _nameText.textColor = YSColor(42, 42, 42);
        _nameText.textAlignment = NSTextAlignmentCenter;
        _nameText.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_nameText];
        
        _view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 100, 1)];
        _view_line.backgroundColor = YSColor(236, 236, 236);
        [self.contentView addSubview:_view_line]; 
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.view_top.backgroundColor = [UIColor orangeColor];
//        self.backgroundColor = YSColor(242, 242, 242);
//    }else{
//        self.view_top.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor whiteColor];
//    }
}
@end
