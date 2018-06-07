//
//  LCPicker.h
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/6.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCPicker;

@protocol  LCPickerDelegate<NSObject>
- (void)lcPickerViewWithPickerView:(LCPicker *)picker str:(NSString *)str;

@end

@interface LCPicker : UIView
@property (nonatomic, strong) NSMutableArray *mutableArr;
@property (nonatomic, weak) id<LCPickerDelegate>delegate;
- (void)animateShow;

@end
