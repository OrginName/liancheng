//
//  ConnectionCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ConnectionCell.h"
@interface ConnectionCell()
@property (weak, nonatomic) IBOutlet UILabel *lab_num;
@property (weak, nonatomic) IBOutlet UILabel *lab_des;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@end
@implementation ConnectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setMo:(UserMo*)mo{
    _mo = mo;
    [self.image_Head sd_setImageWithURL:[NSURL URLWithString:mo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = mo.nickName?mo.nickName:@"无";
    self.lab_des.text = mo.occupationCategoryName[@""]?mo.occupationCategoryName[@""]:@"无";
    self.lab_num.text = KString(@"%@", mo.commonFriendCount);
    if ([[mo.isFriend description] isEqualToString:@"1"]) {
        [self.btn_Add setTitle:@"好友" forState:UIControlStateNormal];
        self.btn_Add.backgroundColor = [UIColor lightGrayColor];
        self.btn_Add.userInteractionEnabled = NO;
    }
}
- (IBAction)addFriens:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(btnClick:)]) {
        [self.cellDelegate btnClick:btn];
    }
    
}
- (IBAction)frinedDetail:(UIButton *)sender {
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(DetailClick:)]) {
        [self.cellDelegate DetailClick:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
