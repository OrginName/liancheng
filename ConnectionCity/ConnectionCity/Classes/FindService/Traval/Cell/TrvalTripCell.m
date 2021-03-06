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
    NSArray * arr = [mo_receive.images componentsSeparatedByString:@";"];
    if (arr.count!=0&&[arr[0] length]!=0) {
        [self.image_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",arr[0],BIGTU]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    }
    self.lab_name.text = mo_receive.introduce?mo_receive.introduce:@"-";
    self.lab_ageAndCity.text = [NSString stringWithFormat:@"%@ %@",mo_receive.user.nickName?mo_receive.user.nickName:@"-",mo_receive.cityName?mo_receive.cityName:@"-"];
    
}
@end
