//
//  TrvalTripCell.m
//  ConnectionCity
//
//  Created by qt on 2018/5/30.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "TrvalTripCell.h"
@interface TrvalTripCell()
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_ageAndCity;
@end
@implementation TrvalTripCell
-(void)setMo_receive:(trvalMo *)mo_receive{
    _mo_receive = mo_receive;
    [self.image_head sd_setImageWithURL:[NSURL URLWithString:[mo_receive.images componentsSeparatedByString:@";"][0]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    self.lab_name.text = mo_receive.user1.nickName;
    self.lab_ageAndCity.text = [NSString stringWithFormat:@"%@岁   %@",mo_receive.user1.age?mo_receive.user1.age:@"",mo_receive.cityName?mo_receive.cityName:@""];
    
}
@end
