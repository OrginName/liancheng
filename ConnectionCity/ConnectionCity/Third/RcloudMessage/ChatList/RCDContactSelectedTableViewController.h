//
//  RCDContactSelectedTableViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/3/17.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <UIKit/UIKit.h>

@protocol RCDContactDelegate <NSObject>
@optional
- (void)optionalFouction;
@end
@interface RCDContactSelectedTableViewController
    : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,assign) id<RCDContactDelegate>delegate;
@property (nonatomic,assign)int flagStr;

@property(nonatomic, strong) NSArray *keys;

@property(nonatomic, strong) NSMutableDictionary *allFriends;

@property(nonatomic, strong) NSArray *allKeys;

@property(nonatomic, strong) NSString *titleStr;

@property(nonatomic, strong) NSMutableArray *addGroupMembers;

@property(nonatomic, strong) NSMutableArray *delGroupMembers;

@property(nonatomic, strong) NSString *groupId;

@property(nonatomic, assign) BOOL forCreatingGroup;

@property(nonatomic, assign) BOOL forCreatingDiscussionGroup;

@property(nonatomic, strong) NSMutableArray *addDiscussionGroupMembers;

@property(nonatomic, strong) NSString *discussiongroupId;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) void (^selectUserList)(NSArray<RCUserInfo *> *selectedUserList);

@property BOOL isAllowsMultipleSelection;

@property BOOL isHideSelectedIcon;

@end
