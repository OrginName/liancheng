//
//  GlobalManager.h
//  dumbbell
//
//  Created by JYS on 16/4/2.
//  Copyright © 2016年 insaiapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalManager : NSObject

+ (GlobalManager *)globalManagerShare;
- (BOOL)isOrNoLogin;

@end
