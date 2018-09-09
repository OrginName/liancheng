//
//  EditAllController.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/13.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^EditBlock)(NSString * EditStr);
@interface EditAllController : BaseViewController
@property (weak, nonatomic) IBOutlet CustomtextView *textView_EditAll;
@property (nonatomic, copy) EditBlock block;
@property (nonatomic,copy) NSString * receiveTxt;
@end
