//
//  AddNewContact1Controller.h
//  ConnectionCity
//
//  Created by qt on 2018/12/2.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^refreshBlock) (void);
@interface AddNewContact1Controller : BaseViewController
@property (nonatomic,copy)refreshBlock blcok;
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;

@end
