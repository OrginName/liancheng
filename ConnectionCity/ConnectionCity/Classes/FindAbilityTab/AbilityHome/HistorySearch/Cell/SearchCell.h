//
//  SearchCell.h
//  ConnectionCity
//
//  Created by qt on 2018/5/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
//选择历史搜索记录
extern NSString * const SearchCellDidChangeNotification;

@interface SearchCell : UITableViewCell
@property (nonatomic, copy) NSArray *cityNameArray;

@end
