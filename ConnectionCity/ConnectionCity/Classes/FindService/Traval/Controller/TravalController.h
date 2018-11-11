//
//  TravalController.h
//  ConnectionCity
//
//  Created by qt on 2018/5/28.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"
#import "TrvalTrip.h"
@interface TravalController : BaseViewController
@property (nonatomic,assign) BOOL isInvitOrTrval;
@property (nonatomic,strong) TrvalTrip * trval;
@property (weak, nonatomic)  IBOutlet MyTab *tab_Bottom;
@property (nonatomic,assign) NSInteger  page;
-(void)requstLoad:(NSDictionary *) dic;
@end
