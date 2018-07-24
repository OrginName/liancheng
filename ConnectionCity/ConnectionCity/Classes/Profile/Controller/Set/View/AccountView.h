//
//  AccountView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/6/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMo.h"
@protocol AccountViewDelegate <NSObject>
@optional
- (void)selectedItemButton:(UserMo *)user;
@end
@interface AccountView : UIView
@property (nonatomic,assign) id<AccountViewDelegate>delegate;
@end

@interface AccountViewCell : UITableViewCell
@property (nonatomic,strong)UserMo * user;
@end

