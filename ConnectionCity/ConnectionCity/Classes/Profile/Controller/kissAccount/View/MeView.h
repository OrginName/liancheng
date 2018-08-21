//
//  MeView.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/8/18.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeView : UIView
@property (nonatomic, strong) NSString *refreshStr;
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller;
- (void)getHeaderData;
@end
