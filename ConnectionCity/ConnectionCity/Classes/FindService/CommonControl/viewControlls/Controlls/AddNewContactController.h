//
//  AddNewContactController.h
//  ConnectionCity
//
//  Created by qt on 2018/11/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^refreshBlock) (void);
@interface AddNewContactController : BaseViewController
@property (nonatomic,strong)NSDictionary * dicReceive;
@property (nonatomic,copy) refreshBlock blcok;
@end
