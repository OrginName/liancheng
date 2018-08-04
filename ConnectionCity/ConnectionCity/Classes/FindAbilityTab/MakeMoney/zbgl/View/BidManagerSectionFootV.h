//
//  BidManagerSectionFootV.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstControllerMo.h"
@class BidManagerSectionFootV;

@protocol BidManagerSectionFootVDelegate <NSObject>

- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view changeBtnClick:(UIButton *)btn;
- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view deleteBtnClick:(UIButton *)btn;
- (void)BidManagerSectionFootV:(BidManagerSectionFootV *)view negotiationBtnClick:(UIButton *)btn;

@end

@interface BidManagerSectionFootV : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *negotiationBtn;
@property (weak, nonatomic) IBOutlet UILabel *reviewStatusLab;
@property (nonatomic, weak) id<BidManagerSectionFootVDelegate>delegate;
@property (nonatomic, strong) FirstControllerMo *model;

@end
