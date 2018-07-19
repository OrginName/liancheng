//
//  CustomAnnotationView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/5/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end
