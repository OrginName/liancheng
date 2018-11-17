//
//  VideoController.h
//  ConnectionCity
//
//  Created by qt on 2018/11/16.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoController : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *coll_Bottom;
@property (nonatomic,strong)NSString * userID;
@end
