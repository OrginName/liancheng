//
//  CircleCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "myServiceMo.h"
@interface CircleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_Head;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Content;
@property (weak, nonatomic) IBOutlet UILabel *lab_HF;
@property (weak, nonatomic) IBOutlet UILabel *lab_time;
@property (nonatomic,strong) Comment * moment;
@property (nonatomic,strong) ObjComment * mo;
@end
