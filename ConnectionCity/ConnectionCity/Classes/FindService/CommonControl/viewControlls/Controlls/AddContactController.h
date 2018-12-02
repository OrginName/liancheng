//
//  AddContactController.h
//  ConnectionCity
//
//  Created by qt on 2018/11/27.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface AddContactController : BaseViewController

@end

@interface AddContactCell : UITableViewCell
@property(nonatomic,strong)UIImageView * imgaRen;
@property (nonatomic,strong)UILabel * lab_Phone;
@property (nonatomic,strong)UIButton * btn_GL;
@property (nonatomic,strong)UIView * view_line;
@property (nonatomic,strong)NSDictionary * dic;
@end
