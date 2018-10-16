//
//  RCDContactViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/16.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDContactViewController.h"
#import "DefaultPortraitView.h"
#import "RCDAddressBookTableViewCell.h"
#import "RCDAddressBookViewController.h"
#import "RCDCommonDefine.h"
#import "RCDContactTableViewCell.h"
#import "RCDGroupViewController.h"
#import "RCDHttpTool.h"
#import "RCDPersonDetailViewController.h"
#import "RCDPublicServiceListViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDSearchFriendViewController.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "pinyin.h"
#import "RCDUIBarButtonItem.h"
#import "RCDUserInfoManager.h"
#import "RCDUtilities.h"
#import "RCDForwardAlertView.h"
#import "FoundQunController.h"
#import "RCDChatViewController.h"
#import "UITabBar+badge.h"
#import "ContactCell.h"
@interface RCDContactViewController ()
@property(strong, nonatomic) NSMutableArray *matchFriendList;
@property(strong, nonatomic) NSArray *defaultCellsTitle;
@property(strong, nonatomic) NSArray *defaultCellsPortrait;
@property(nonatomic, assign) BOOL hasSyncFriendList;
@property(nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray * arr_Data;
@end

@implementation RCDContactViewController
- (void)setUpView {
    [self.friendsTabelView
        setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];

    [self.view addSubview:self.friendsTabelView];
    [self.view addSubview:self.searchFriendsBar];
    self.friendsTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
//    [self.friendsTabelView.mj_header beginRefreshing];
}

- (UISearchBar *)searchFriendsBar {
    if (!_searchFriendsBar) {
        _searchFriendsBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 0, RCDscreenWidth - 4, 28)];
        [_searchFriendsBar sizeToFit];
        [_searchFriendsBar setPlaceholder:NSLocalizedStringFromTable(@"ToSearch", @"RongCloudKit", nil)];
        [_searchFriendsBar.layer setBorderWidth:0.5];
        [_searchFriendsBar.layer
            setBorderColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1].CGColor];
        [_searchFriendsBar setDelegate:self];
        [_searchFriendsBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchFriendsBar;
}

- (UITableView *)friendsTabelView {
    if (!_friendsTabelView) {
        CGRect searchBarFrame = self.searchFriendsBar.frame;
        CGFloat originY = CGRectGetMaxY(searchBarFrame);
        _friendsTabelView = [[UITableView alloc]
                             initWithFrame:CGRectMake(0, originY, self.view.width, self.view.height - searchBarFrame.size.height)
                    style:UITableViewStyleGrouped];
        
        _friendsTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        if ([_friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            _friendsTabelView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        if ([_friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            _friendsTabelView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        [_friendsTabelView setDelegate:self];
        [_friendsTabelView setDataSource:self];
        [_friendsTabelView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_friendsTabelView setSectionIndexColor:[UIColor darkGrayColor]];
        [_friendsTabelView
            setBackgroundColor:[UIColor colorWithRed:240.0 / 255 green:240.0 / 255 blue:240.0 / 255 alpha:1]];
        //        _friendsTabelView.style = UITableViewStyleGrouped;
        //        _friendsTabelView.tableHeaderView=self.searchFriendsBar;
        // cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_friendsTabelView setTableFooterView:v];
    }
    return _friendsTabelView;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:
//     [UIImage imageNamed:@"椭圆2拷贝4"] forBarMetrics:UIBarMetricsDefault];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    [self setUpView];
    // initial data
    self.matchFriendList = [[NSMutableArray alloc] init];
    self.allFriendSectionDic = [[NSDictionary alloc] init];
    self.arr_Data = [NSMutableArray array];
    self.friendsTabelView.tableFooterView = [UIView new];
    self.friendsTabelView.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.friendsTabelView.separatorColor = HEXCOLOR(0xdfdfdf);
    self.friendsTabelView.tableHeaderView =
        [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.friendsTabelView.bounds.size.width, 0.01f)];
    //设置右侧索引
    self.friendsTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.friendsTabelView.sectionIndexColor = HEXCOLOR(0x555555);

//    if ([self.friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.friendsTabelView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
//    }
//    if ([self.friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.friendsTabelView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
//    }

    UIImage *searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置顶部搜索栏的背景图片
    [self.searchFriendsBar setBackgroundImage:searchBarBg];
    //设置顶部搜索栏的背景色
    [self.searchFriendsBar setBackgroundColor:HEXCOLOR(0xf0f0f6)];

    //设置顶部搜索栏输入框的样式
    UITextField *searchField = [self.searchFriendsBar valueForKey:@"_searchField"];
    searchField.layer.borderWidth = 0.5f;
    searchField.layer.borderColor = [HEXCOLOR(0xdfdfdf) CGColor];
    searchField.layer.cornerRadius = 5.f;
    self.searchFriendsBar.placeholder = @"搜索";
//@"公众号"
    self.defaultCellsTitle = [NSArray arrayWithObjects:@"新朋友", @"群组" , nil];
    self.defaultCellsPortrait = [NSArray arrayWithObjects:@"our-np", @"our-qiye", nil];
    self.isBeginSearch = NO;
    if ([RCDForwardMananer shareInstance].isForward) {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(onCancelAction)];
        self.navigationItem.leftBarButtonItem = left;
    }
    //自定义rightBarButtonItem
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"jiaru"]
                                                                 imageViewFrame:CGRectMake(0, 0, 18, 20)
                                                                    buttonTitle:nil
                                                                     titleColor:nil
                                                                     titleFrame:CGRectZero
                                                                    buttonFrame:CGRectMake(0, 0, 18, 20)
                                                                         target:self
                                                                         action:@selector(pushAddFriend:)];
    self.navigationItem.rightBarButtonItems = [rightBtn setTranslation:rightBtn translation:-6];
    
    self.tabBarController.navigationItem.title = @"通讯录";
    [self.searchFriendsBar resignFirstResponder];
    
    [self updateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"MYADDRESSBOOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBage:) name:@"JOINACTIVE" object:nil];
}
#pragma mark -----------更新角标--------------------------
-(void)updateBage:(NSNotification *)noti{
    RCDContactTableViewCell * cell = [self.friendsTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIView * view = (UIView *)[cell.contentView viewWithTag:1000000];
    NSDictionary * dic = noti.object;
    if ([dic[@"num"] intValue]==0) {
        [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        view.hidden = YES;
    }else{
        [self.tabBarController.tabBar showBadgeOnItemIndex:2 badgeValue:[dic[@"num"] intValue]];
        view.hidden = NO;
    }
}
-(void)updateData{
    [self sortAndRefreshWithList:[self getAllFriendList]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isBeginSearch == YES) {
        [self sortAndRefreshWithList:[self getAllFriendList]];
        _isBeginSearch = NO;
        self.searchFriendsBar.showsCancelButton = NO;
        [self.searchFriendsBar resignFirstResponder];
        self.searchFriendsBar.text = @"";
        [self.matchFriendList removeAllObjects];
//        [self.friendsTabelView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        if (_isBeginSearch == YES) {
            rows = 0;
        } else {
            rows = 3;
        }
    } else {
        NSString *letter = self.resultDic[@"allKeys"][section - 1];
        rows = [self.allFriendSectionDic[letter] count];
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultDic[@"allKeys"] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 21.f;
}

//如果没有该方法，tableView会默认显示footerView，其高度与headerView等高
//另外如果return 0或者0.0f是没有效果的
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
    view.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.frame = CGRectMake(13, 3, 15, 15);
    title.font = [UIFont systemFontOfSize:15.f];
    title.textColor = HEXCOLOR(0x999999);

    [view addSubview:title];

    if (section == 0) {
        title.text = nil;
    } else {
        title.text = self.resultDic[@"allKeys"][section - 1];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *isDisplayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayID"];
    
    static NSString *reusableCellWithIdentifier = @"ContactCell";
    ContactCell * cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
//    RCDContactTableViewCell *cell =
//        [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
//    if (cell == nil) {
//        cell = [[RCDContactTableViewCell alloc] init];
//    }
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
    }

    if (indexPath.section == 0 && indexPath.row < 2) {
//        if ([RCDForwardMananer shareInstance].isForward && indexPath.section == 0 && indexPath.row == 0) {
//
//        }else{
//            if (indexPath.row==0) {
//                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(110, 22, 10, 10)];
//                view.backgroundColor = [UIColor redColor];
//                view.alpha = 0.8;
//                view.tag = 1000000;
//                view.hidden = YES;
//                view.layer.cornerRadius = 5;
//                view.layer.masksToBounds = YES;
//                [cell.contentView addSubview:view];
//            }
            cell.nicknameLabel.text = _defaultCellsTitle[indexPath.row];
            [cell.portraitView
             setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", _defaultCellsPortrait[indexPath.row]]]];
//        }
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
//        if ([isDisplayID isEqualToString:@"YES"]) {
//            cell.userIdLabel.text = [RCIM sharedRCIM].currentUserInfo.userId;
//        }
       
        cell.nicknameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
        [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri]
                             placeholderImage:[UIImage imageNamed:@"contact"]];
    }
    if (indexPath.section != 0) {
        NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];

        NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
        RCDUserInfo *userInfo = sectionUserInfoList[indexPath.row];
        if (userInfo) {
//            if ([isDisplayID isEqualToString:@"YES"]) {
//                cell.userIdLabel.text = userInfo.userId;
//            }
            if ([[userInfo.status description] isEqualToString:@"0"]||[[userInfo.status description] isEqualToString:@"2"]) {
                 cell.statusLabel.text = @"【离线】";
            }
            cell.nicknameLabel.text = [userInfo.name isEqualToString:@"<null>"]?userInfo.userId:userInfo.name;
            
//            if ([userInfo.portraitUri isEqualToString:@""]) {
//                DefaultPortraitView *defaultPortrait =
//                    [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//                [defaultPortrait setColorAndLabel:userInfo.userId Nickname:userInfo.name];
//                UIImage *portrait = [defaultPortrait imageFromView];
//                cell.portraitView.image = portrait;
//            } else {
                [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri]
                                     placeholderImage:[UIImage imageNamed:@"contact"]];
//            }
        }
    }
//    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE &&
//        [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
//        cell.portraitView.layer.masksToBounds = YES;
//        cell.portraitView.layer.cornerRadius = 20.f;
//    } else {
//        cell.portraitView.layer.masksToBounds = YES;
//        cell.portraitView.layer.cornerRadius = 5.f;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([RCDForwardMananer shareInstance].isForward && indexPath.section == 0 && indexPath.row == 0) {
        return 0.01;
    }
    return 55.5;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.resultDic[@"allKeys"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.friendsTabelView deselectRowAtIndexPath:indexPath animated:YES];
    RCDUserInfo *user = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
        case 0: {
            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
            [self.navigationController pushViewController:addressBookVC animated:YES];
            return;
        } break;

        case 1: {
            FoundQunController * foun = [FoundQunController new];
            foun.title = @"群";
            [self.navigationController pushViewController:foun animated:YES];
            return;

        } break;

        case 2: {
//            if ([RCDForwardMananer shareInstance].isForward) {
//                RCConversation *conver = [[RCConversation alloc] init];
//                conver.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
//                conver.conversationType = ConversationType_PRIVATE;
//                [RCDForwardMananer shareInstance].toConversation = conver;
//                [[RCDForwardMananer shareInstance] showForwardAlertViewInViewController:self];
//                return;
//            }
//
//            RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc] init];
//            [self.navigationController pushViewController:detailViewController animated:YES];
//            detailViewController.userId = [RCIM sharedRCIM].currentUserInfo.userId;
            //创建会话
            RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
            chatViewController.conversationType = ConversationType_PRIVATE;
            chatViewController.targetId = [RCIM sharedRCIM].currentUserInfo.userId;
            chatViewController.title = [RCIM sharedRCIM].currentUserInfo.name?[RCIM sharedRCIM].currentUserInfo.name:[RCIM sharedRCIM].currentUserInfo.userId;
            chatViewController.displayUserNameInCell = NO;
            [self.navigationController pushViewController:chatViewController animated:YES];
            return;
        }
        default:
            break;
        }
    }
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    user = sectionUserInfoList[indexPath.row];
    if (user == nil) {
        return;
    }
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = [user.userId description];
    userInfo.portraitUri = user.portraitUri;
    userInfo.name = user.name;
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    chatViewController.targetId = [userInfo.userId description];
    chatViewController.title = userInfo.name;
    chatViewController.userInfo = user;
    chatViewController.displayUserNameInCell = NO;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchFriendsBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.matchFriendList removeAllObjects];
    if (searchText.length <= 0) {
        [self sortAndRefreshWithList:self.arr_Data];
    } else {
        for (RCDUserInfo *userInfo in self.arr_Data) {
            //忽略大小写去判断是否包含
            if ([userInfo.mobilePhone rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.mobilePhone] rangeOfString:searchText
                                                                            options:NSCaseInsensitiveSearch]
                .location != NSNotFound||[userInfo.userId rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[RCDUtilities hanZiToPinYinWithString:userInfo.userId] rangeOfString:searchText
                                                                                   options:NSCaseInsensitiveSearch]
                .location != NSNotFound||[userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound||[[RCDUtilities hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText
                                                                                                                                                                                                        options:NSCaseInsensitiveSearch]
                .location != NSNotFound) {
                [self.matchFriendList addObject:userInfo];
            }
        }
        [self sortAndRefreshWithList:self.matchFriendList];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchFriendsBar.showsCancelButton = NO;
    [self.searchFriendsBar resignFirstResponder];
    self.searchFriendsBar.text = @"";
    [self.matchFriendList removeAllObjects];
    [self sortAndRefreshWithList:self.arr_Data];
    _isBeginSearch = NO;
    [self.friendsTabelView reloadData];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (_isBeginSearch == NO) {
        _isBeginSearch = YES;
        [self.friendsTabelView reloadData];
    }
    self.searchFriendsBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#pragma mark - 获取好友并且排序
- (NSArray *)getAllFriendList {
    __block NSMutableArray *friendList = [[NSMutableArray alloc] init];
    WeakSelf
//    NSMutableArray *userInfoList = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
//    for (RCDUserInfo *user in userInfoList) {
//        if ([user.status isEqualToString:@"20"]) {
//            [friendList addObject:user];
//        }
//    }
//    if (friendList.count <= 0 && !self.hasSyncFriendList) {
    
        [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                             complete:^(NSMutableArray *result) {
//                                 [result removeAllObjects]; 
                                 weakSelf.hasSyncFriendList = YES;
                                 [weakSelf sortAndRefreshWithList:result];
                                 weakSelf.arr_Data = result;
                                 [weakSelf.friendsTabelView.mj_header endRefreshing];
                             }];
//    }
    //如有好友备注，则显示备注
    NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:friendList];
    return resultList;
}
- (void)sortAndRefreshWithList:(NSArray *)friendList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.resultDic = [RCDUtilities sortedArrayWithPinYinDic:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allFriendSectionDic = self.resultDic[@"infoDic"];
            [self.friendsTabelView reloadData];
        });
    });
}
/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void)pushAddFriend:(id)sender {
    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
    [self.navigationController pushViewController:searchFirendVC animated:YES];
}
- (UIImage *)GetImageWithColor:(UIColor *)color andHeight:(CGFloat)height {
    CGRect r = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

- (void)onCancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[RCDForwardMananer shareInstance] clear];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
