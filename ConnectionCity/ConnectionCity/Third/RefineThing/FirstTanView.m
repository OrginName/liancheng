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
#import "SendServiceController.h"
#import "SendTripController.h"
#import "ReleaseTenderController.h"
#import "SendSwapController.h"
@implementation FirstTanView
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (IBAction)FirstTanClick:(UIButton *)sender {
    if (sender.tag==5) {
        
    }else{
        NSArray * arr = @[@"SendServiceController",@"SendTripController",@"ReleaseTenderController",@"SendSwapController"];
        [self.messController.navigationController pushViewController:[self rotateClass:arr[sender.tag-1]] animated:YES];
//        AddressBookController * address = [AddressBookController new];
//        address.title = @"测试标题";
//       [self.messController.navigationController pushViewController:address animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLOSEANI object:nil];
    
}
/**
 类名转换类
 
 @param name 类名
 */
-(UIViewController *)rotateClass:(NSString *)name{
    Class c = NSClassFromString(name);
    UIViewController * controller;
#if __has_feature(objc_arc)
    controller = [[c alloc] init];
#else
    controller = [[[c alloc] init] autorelease];
#endif
    return controller;
}
@end
