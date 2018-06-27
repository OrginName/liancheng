//
//  FriendVideoCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendVideoCell.h"
@interface FriendVideoCell()
@property (weak, nonatomic) IBOutlet UILabel *lab_content;
@property (weak, nonatomic) IBOutlet UILabel *lab_User;
@property (weak, nonatomic) IBOutlet UIImageView *image_cover;
@property (weak, nonatomic) IBOutlet UIImageView *image_User;
@property (weak, nonatomic) IBOutlet UIButton *btn_Zan;
@end
@implementation FriendVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMoment:(Moment *)moment{
    _moment = moment;
    self.lab_User.text = moment.userMo.nickName;
    self.lab_content.text = moment.content;
    self.image_cover.image = moment.coverImage;
    [self.image_User sd_setImageWithURL:[NSURL URLWithString:moment.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    [self.btn_Zan setTitle:KString(@"%@", moment.likeCount) forState:UIControlStateNormal];
}
- (IBAction)btnClick:(UIButton *)sender {
}
@end
