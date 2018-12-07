//
//  MiddleCell.h
//  ConnectionCity
//
//  Created by qt on 2018/11/24.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^middleClick)(NSInteger tag);
@interface MiddleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (nonatomic,strong) NSMutableArray * arr;
@property (nonatomic,strong) middleClick middBlock;
@end
