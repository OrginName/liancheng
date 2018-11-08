//
//  FriendCircleController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "UserMo.h"
#import "FriendCirleTab.h"
#import "FriendVideo.h"
@interface FriendCircleController : BaseViewController
@property (nonatomic, assign) BOOL showOrHidden;
@property (nonatomic, strong) UserMo * user;//当前传进来的userID
@property (nonatomic,strong) NSString * flagCircle;
@property (nonatomic,strong)FriendCirleTab * frendTab;
@property (nonatomic,strong)FriendVideo * frendVedio;
@end
