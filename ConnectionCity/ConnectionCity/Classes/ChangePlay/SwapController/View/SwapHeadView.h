//
//  SwapHeadView.h
//  ConnectionCity
//
//  Created by qt on 2018/5/22.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwapHeadDelegate <NSObject>
@optional
-(void)swapHeadClick:(NSInteger )tag;
@end

@interface SwapHeadView : UIView
@property (nonatomic,assign) id<SwapHeadDelegate>delegate;
@end
