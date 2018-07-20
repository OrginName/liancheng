//
//  CollectionCell.m
//  ConnectionCity
//
//  Created by qt on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "CollectionCell.h"
#import "UIView+Geometry.h"
#import "MMImageListView.h"
#import "Utility.h"
// 视图之间的间距
#define kPaddingValue  8
@interface CollectionCell()
@property (nonatomic,strong)UIImageView * image_head;
@property (nonatomic,strong)UILabel * lab_title;
@property (nonatomic,strong)UILabel * lab_Time;
@property (nonatomic,strong)UILabel * lab_desc;
@property (nonatomic,strong)MMImageListView * listView;
@property (nonatomic,strong)UIButton * btn_Cancle;
@property (nonatomic,strong)UIImageView * imagePlay;
@end
@implementation CollectionCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.image_head];
        [self addSubview:self.lab_title];
        [self addSubview:self.lab_Time];
        [self addSubview:self.btn_Cancle];
        [self addSubview:self.lab_desc];
        [self addSubview:self.listView];
        [self addSubview:self.imagePlay];
    }
    return self;
}
-(void)setReceive_Mo:(Moment *)receive_Mo{
    _receive_Mo = receive_Mo;
    // 头像
    [_image_head sd_setImageWithURL:[NSURL URLWithString:receive_Mo.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    // 昵称
    _lab_title.text = receive_Mo.userMo.nickName?receive_Mo.userMo.nickName:receive_Mo.userMo.ID;
    _lab_Time.text = [receive_Mo.createTime componentsSeparatedByString:@" "][0];
    CGFloat bottom = _lab_Time.bottom + kPaddingValue;
    if ([receive_Mo.text length]) {
        _lab_desc.text = receive_Mo.text;
        CGFloat labH = [self calculateRowHeight:receive_Mo.text fontSize:13];
        _lab_desc.numberOfLines = 0;
        _lab_desc.frame = CGRectMake(_image_head.right, bottom, kScreenWidth-40, labH);
        bottom = _lab_desc.bottom + kPaddingValue;
    }
    // 图片
    _listView.moment = receive_Mo;
    if (receive_Mo.fileCount > 0) {
        _listView.origin = CGPointMake(_image_head.right, bottom);
        bottom = _listView.bottom + kPaddingValue;
        receive_Mo.cellHeight = _listView.bottom+10;
    }else if(receive_Mo.videos.length!=0){
        _imagePlay.image = receive_Mo.coverImage;
        _imagePlay.frame = CGRectMake(_lab_desc.left, _lab_desc.bottom+5, 40, 60);
        receive_Mo.cellHeight = _imagePlay.bottom+10;
    }else{
        receive_Mo.cellHeight = _lab_desc.bottom+10;
    }
    
}
//点击展开
-(void)DescClick{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _receive_Mo.isFullText = !_receive_Mo.isFullText;
        if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
            [self.delegate didSelectFullText:self];
        }
    });
}
- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.width-40, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
-(UIImageView *)image_head{
    if (!_image_head) {
        _image_head = [[UIImageView alloc] init];
        _image_head.image = [UIImage imageNamed:@"1"];
        _image_head.frame = CGRectMake(10, 15, 30, 30);
        _image_head.layer.cornerRadius = 5;
        _image_head.layer.masksToBounds = YES;
    }
    return _image_head;
}
-(UILabel *)lab_title{
    if (!_lab_title) {
        _lab_title = [[UILabel alloc] initWithFrame:CGRectMake(self.image_head.right+10, self.image_head.top-5, self.width-self.image_head.right,15)];
        _lab_title.textColor = YSColor(43, 43, 43);
        _lab_title.font = [UIFont systemFontOfSize:14];
        _lab_title.text = @"大海的孩子";
    }
    return _lab_title;
}
-(UILabel *)lab_Time{
    if (!_lab_Time) {
        _lab_Time = [[UILabel alloc] initWithFrame:CGRectMake(self.lab_title.left, self.lab_title.bottom+5, self.lab_title.width, 15)];
        _lab_Time.textColor = YSColor(188, 188, 188);
        _lab_Time.font = [UIFont systemFontOfSize:13];
    }
    return _lab_Time;
}
-(UILabel *)lab_desc{
    if (!_lab_desc) {
        _lab_desc = [[UILabel alloc] initWithFrame:CGRectZero];
        _lab_desc.textColor = YSColor(43, 43, 43);
        _lab_desc.font = [UIFont systemFontOfSize:13];
        _lab_desc.numberOfLines = 3;
        _lab_desc.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DescClick)];
        [_lab_desc addGestureRecognizer:tap];
    }
    return _lab_desc;
}
-(MMImageListView *)listView{
    if (!_listView) {
        // 图片区
        _listView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    }
    return _listView;
}
-(UIButton *)btn_Cancle{
    if (!_btn_Cancle) {
        _btn_Cancle = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, self.lab_title.bottom-10, 60, 20)];
        [_btn_Cancle setTitle:@"取消收藏" forState:UIControlStateNormal];
        [_btn_Cancle setBackgroundColor:YSColor(236, 95, 90)];
        [_btn_Cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_Cancle.titleLabel.font = [UIFont systemFontOfSize:11];
        _btn_Cancle.layer.cornerRadius = 5;
        _btn_Cancle.layer.masksToBounds = YES;
    }
    return _btn_Cancle;
}
-(UIImageView *)imagePlay{
    if (!_imagePlay) {
        _imagePlay = [[UIImageView alloc] init];
        UIImageView * image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"q-play"];
        image.center = _imagePlay.center;
        image.frame = CGRectMake(0, 0, 30, 30);
        [_imagePlay addSubview:image];
    }
    return _imagePlay;
}
@end
