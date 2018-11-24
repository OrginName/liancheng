//
//  HeadView.m
//  ConnectionCity
//
//  Created by qt on 2018/11/23.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.view_Top];
        [self addSubview:self.lab_title];
        [self addSubview:self.lab_more];
        [self addSubview:self.image_right];
    }
    return self;
}
-(UIView *)view_Top{
    if (!_view_Top) {
        _view_Top = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 5, 20)];
        _view_Top.backgroundColor = YSColor(255, 175, 15);
        _view_Top.layer.cornerRadius = 2.5;
        _view_Top.layer.masksToBounds = YES;
    }
    return _view_Top;
}
-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 40)];
        _lab_title.text = @"附近动态";
        _lab_title.textColor = [UIColor blackColor];
        _lab_title.font = [UIFont systemFontOfSize:17];
        _lab_title.textColor = YSColor(2, 4, 6);
    }
    return _lab_title;
}
-(UILabel *)lab_more{
    if (!_lab_more) {
        _lab_more=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-85, 0, 50, 40)];
        _lab_more.text = @"更多";
        _lab_more.textAlignment = NSTextAlignmentRight;
        _lab_more.font = [UIFont systemFontOfSize:16];
        _lab_more.textColor = YSColor(150, 151, 152);
    }
    return _lab_more;
}
-(UIImageView *)image_right{
    if (!_image_right) {
        _image_right = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 12.5, 10, 15)];
        _image_right.image =[UIImage imageNamed:@"arraw-right"];
    }
    return _image_right;
}
@end
