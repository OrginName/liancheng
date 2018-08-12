//
//  JFSearchView.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/24.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityMo.h"
#import "ShoolOREduMo.h"
@protocol JFSearchViewDelegate <NSObject>
@optional
-(void)serchResultCityMo:(CityMo *) mo;
@optional
-(void)serchResultSchoolMo:(ShoolOREduMo *) mo;
@optional
- (void)searchResults:(NSDictionary *)dic;
@optional
- (void)touchViewToExit;
@end

@interface JFSearchView : UIView

/** 搜索结果*/
@property (nonatomic, strong) NSMutableArray *resultMutableArray;
@property (nonatomic, weak) id<JFSearchViewDelegate> delegate;
@end
