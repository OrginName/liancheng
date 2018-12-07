//
//  MiddleCell.m
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MiddleCell.h"
#import "ReceMo.h"
@implementation MiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)MiddleClick:(UIButton *)sender {
    if (self.middBlock) {
        self.middBlock(sender.tag);
    }
}
-(void)setArr:(NSMutableArray *)arr{
    _arr = arr;
    NSArray * arr1 = @[self.image1,self.image2,self.image3,self.image4];
    for (int i=0; i<arr.count; i++) {
        ActivityMo * mo = arr[i];
        [arr1[i] sd_setImageWithURL:[NSURL URLWithString:mo.url] placeholderImage:[UIImage imageNamed:@"button"]];
    } 
}
@end
