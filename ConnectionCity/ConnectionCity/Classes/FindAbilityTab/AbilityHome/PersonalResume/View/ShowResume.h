//
//  ShowResume.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/25.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^btnClickBlock)(void);
@interface ShowResume : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageTurn;
@property (weak, nonatomic) IBOutlet UILabel *lab_nametitle;
@property (nonatomic,copy)btnClickBlock block;
@end
