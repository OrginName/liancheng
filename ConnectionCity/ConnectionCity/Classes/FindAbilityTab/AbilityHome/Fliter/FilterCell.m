//
//  FilterCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/11.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FilterCell.h"
#import "YSConstString.h"
@interface FilterCell()
//@property (nonatomic, strong) UILabel * lab_title;

@end
@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lab_title];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
   _lab_title.frame = self.bounds;
}
#pragma mark - config cell

- (void)configCellWithData:(NSDictionary *)dic {
    
    _lab_title.text = dic[@"title"];
    if ([dic[@"isSelected"] boolValue]) {
        _lab_title.layer.borderColor = [UIColor hexColorWithString:@"#f49930"].CGColor;
        _lab_title.textColor = [UIColor hexColorWithString:@"#f49930"];
        self.selected = YES;
        
    } else {
        _lab_title.layer.borderColor = YSColor(246, 246, 246).CGColor;
        _lab_title.textColor = [UIColor hexColorWithString:@"#282828"];
        self.selected = NO;
    }
}
#pragma mark - setter and getter
- (UILabel *)lab_title {
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] init];
        _lab_title.layer.borderColor = YSColor(246, 246, 246).CGColor;
        _lab_title.layer.cornerRadius = 5.0;
        _lab_title.layer.borderWidth = 1;
        _lab_title.layer.masksToBounds = YES;
        _lab_title.textAlignment = NSTextAlignmentCenter;
        _lab_title.font = [UIFont systemFontOfSize:15];
    }
    return _lab_title;
}
@end
