//
//  FirstTanView.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "FirstTanView.h"
#import "AddressBookController.h"
#import "YSConstString.h"
@implementation FirstTanView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (IBAction)FirstTanClick:(UIButton *)sender {
    if (sender.tag==5) {
        
    }else{
        AddressBookController * address = [AddressBookController new];
        address.title = @"测试标题";
       [self.messController.navigationController pushViewController:address animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
    
}
@end