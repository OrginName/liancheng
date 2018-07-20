//
//  ShowResume1.h
//  ConnectionCity
//
//  Created by umbrella on 2018/7/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^btnClickBlock)(void);
@interface ShowResume1 : UIView
@property (nonatomic,copy)btnClickBlock block;
@property (weak, nonatomic) IBOutlet UIImageView * imageTurn;
@property (weak, nonatomic) IBOutlet UILabel * lab_nametitle;
@end
