//
//  NewsListController.h
//  ConnectionCity
//
//  Created by qt on 2018/11/4.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsListController : BaseViewController
@property (nonatomic,assign) NSInteger  page;
-(void)requstLoad:(NSString *)cityCode;
@property (weak, nonatomic) IBOutlet MyTab *tab_Bottom;
@end
