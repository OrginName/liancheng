//
//  viewPaly.m
//  ConnectionCity
//
//  Created by umbrella on 2018/7/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "viewPaly.h"
#import "CustomPlayer.h"
@interface viewPaly()
@property (nonatomic,strong)UIButton * btn_back;
@property (nonatomic,strong)UIImageView * image_cover;
@property (nonatomic,strong)UIButton * btn_play;
@property (nonatomic,strong)CustomPlayer * player;
@end
@implementation viewPaly
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.btn_back];
    }
    return self;
}
//#pragma 播放事件
//-(void)play{
//
//}
-(void)layoutSubviews{
    
}
//-(UIButton *)btn_play{
//    if (!_btn_play) {
//        _btn_play = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btn_play setBackgroundImage:[UIImage imageNamed:@"q-play"] forState:UIControlStateNormal];
//        [_btn_play addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btn_play;
//}
//-(UIImageView *)image_cover{
//    if (!_image_cover) {
//        _image_cover = [[UIImageView alloc] init];
//
//    }
//    return _image_cover;
//}
-(UIButton *)btn_back{
    if (!_btn_back) {
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_back setBackgroundImage:[UIImage imageNamed:@"q-play"] forState:UIControlStateNormal];
    }
    return _btn_back;
}
@end
