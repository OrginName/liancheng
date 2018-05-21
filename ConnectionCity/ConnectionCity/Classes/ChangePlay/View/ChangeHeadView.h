//
//  ChangeHeadView.h
//  ConnectionCity
//
//  Created by qt on 2018/5/20.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CurrentBlock)(NSInteger  CurrentTag);
@interface ChangeHeadView : UIView
@property (nonatomic,copy) CurrentBlock block;
@end


