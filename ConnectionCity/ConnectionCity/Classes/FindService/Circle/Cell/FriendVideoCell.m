//
//  FriendVideoCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/6/1.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FriendVideoCell.h"
#import "AllDicMo.h"
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
    [self.btn_Zan setTitle:[NSString stringWithFormat:@"%@ 赞",KString(@"%@", moment.likeCount)] forState:UIControlStateNormal];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.btn_Zan.selected) {
        return;
    }
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:KAllDic]];
    AllContentMo * mo = [arr[5] contentArr][4];
    [YSNetworkTool POST:v1CommonCommentAddlike params:@{@"id":self.moment.ID,@"type":mo.value} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        self.btn_Zan.selected = YES;
        [self.btn_Zan setTitle:[NSString stringWithFormat:@"%@ 赞",KString(@"%@", responseObject[@"data"])] forState:UIControlStateNormal];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
@end
