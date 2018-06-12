//
//  PopThree.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/12.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建协议
@protocol PopThreeDelegate <NSObject>
- (void)sendValue:(NSInteger )tag; //声明协议方法
@end
@interface PopThree : UIView
@property (nonatomic,assign) id<PopThreeDelegate>delegate;

@end
