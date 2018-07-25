//
//  NoticeCell.h
//  ConnectionCity
//
//  Created by qt on 2018/7/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMo.h"

@protocol NoticeCellDelegate <NSObject>
@optional
- (void)agreeClik:(UIButton *)btn;
@end

@interface NoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;

@property (weak, nonatomic) IBOutlet UIButton * btn_agree;

@property (nonatomic,strong) NoticeMo * mo;
@property (nonatomic,assign) id<NoticeCellDelegate>delegate;
@end
