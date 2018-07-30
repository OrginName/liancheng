//
//  SortCollProController.m
//  ConnectionCity
//
//  Created by qt on 2018/7/8.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "SortCollProController.h"
#import "pinyin.h"
#import "ShoolOREduMo.h"
#import "RCDCommonDefine.h"
@interface SortCollProController ()
@property(strong, nonatomic) NSMutableArray *matchFriendList;
@property(strong, nonatomic) NSArray *defaultCellsTitle;
@property(strong, nonatomic) NSArray *defaultCellsPortrait;
@property(nonatomic, assign) BOOL hasSyncFriendList;
@property(nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray * data_arr;
@end

@implementation SortCollProController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    self.data_arr = [NSMutableArray array];
    [self setUpView];
    // initial data
    self.matchFriendList = [[NSMutableArray alloc] init];
    self.allFriendSectionDic = [[NSDictionary alloc] init];
    
    self.friendsTabelView.tableFooterView = [UIView new];
    self.friendsTabelView.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.friendsTabelView.separatorColor = HEXCOLOR(0xdfdfdf);
    
    self.friendsTabelView.tableHeaderView =
    [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.friendsTabelView.bounds.size.width, 0.01f)];
    
    //设置右侧索引
    self.friendsTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.friendsTabelView.sectionIndexColor = HEXCOLOR(0x555555);
    
    if ([self.friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendsTabelView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    if ([self.friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.friendsTabelView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    
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
    [self loadData:_url];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchFriendsBar resignFirstResponder];
//    [self sortAndRefreshWithList:[self getAllFriendList]];
    self.tabBarController.navigationItem.title = @"学校";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isBeginSearch == YES) {
//        [self sortAndRefreshWithList:[self getAllFriendList]];
        _isBeginSearch = NO;
        self.searchFriendsBar.showsCancelButton = NO;
        [self.searchFriendsBar resignFirstResponder];
        self.searchFriendsBar.text = @"";
        [self.matchFriendList removeAllObjects];
        [self.friendsTabelView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSString *letter = self.resultDic[@"allKeys"][section];
    rows = [self.allFriendSectionDic[letter] count];
    return rows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultDic[@"allKeys"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.f;
}
//如果没有该方法，tableView会默认显示footerView，其高度与headerView等高
//另外如果return 0或者0.0f是没有效果的
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.frame = CGRectMake(13, 3, 15, 15);
    title.font = [UIFont systemFontOfSize:15.f];
    title.textColor = HEXCOLOR(0x999999);
    
    [view addSubview:title];
    title.text = self.resultDic[@"allKeys"][section];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    UITableViewCell *cell =
    [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
    }
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
        ShoolOREduMo * shool = sectionUserInfoList[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = shool.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.resultDic[@"allKeys"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    ShoolOREduMo * shool = sectionUserInfoList[indexPath.row];
    self.block(shool);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchFriendsBar resignFirstResponder];
}
#pragma mark - 获取好友并且排序
- (void)getAllFriendList:(NSMutableArray *)arr{
    [self sortAndRefreshWithList:[arr copy]];
    self.hasSyncFriendList = YES;
}
- (void)sortAndRefreshWithList:(NSArray *)friendList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.resultDic = [self sortedArrayWithPinYinDic:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allFriendSectionDic = self.resultDic[@"infoDic"];
            [self.friendsTabelView reloadData];
        });
    });
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
        [self sortAndRefreshWithList:self.data_arr];
    } else {
        for (ShoolOREduMo *userInfo in self.data_arr) {
            //忽略大小写去判断是否包含
            if ([userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[self hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText
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
    [self sortAndRefreshWithList:self.data_arr];
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

- (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList {
    if (!userList)
        return nil;
    NSArray *_keys = @[
                       @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N",
                       @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"
                       ];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    NSMutableArray *_tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    for (NSString *key in _keys) {
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        NSMutableArray *tempArr = [NSMutableArray new];
        for (id user in userList) {
            NSString *firstLetter;
            if ([user isMemberOfClass:[ShoolOREduMo class]]) {
                ShoolOREduMo *userInfo = (ShoolOREduMo *)user;
                if (userInfo.name.length > 0 && ![userInfo.name isEqualToString:@""]) {
                    firstLetter = [self getFirstUpperLetter:userInfo.name];
                } else {
                    firstLetter = [self getFirstUpperLetter:userInfo.name];
                }
            }
            if ([firstLetter isEqualToString:key]) {
                [tempArr addObject:user];
            }
            
            if (isReturn)
                continue;
            char c = [firstLetter characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:user];
            }
        }
        if (![tempArr count])
            continue;
        [infoDic setObject:tempArr forKey:key];
    }
    if ([_tempOtherArr count])
        [infoDic setObject:_tempOtherArr forKey:@"#"];
    
    NSArray *keys = [[infoDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:keys];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    [resultDic setObject:infoDic forKey:@"infoDic"];
    [resultDic setObject:allKeys forKey:@"allKeys"];
    return resultDic;
}
-(NSString *)getFirstUpperLetter:(NSString *)hanzi {
    NSString *pinyin = [self hanZiToPinYinWithString:hanzi];
    NSString *firstUpperLetter = [[pinyin substringToIndex:1] uppercaseString];
    if ([firstUpperLetter compare:@"A"] != NSOrderedAscending &&
        [firstUpperLetter compare:@"Z"] != NSOrderedDescending) {
        return firstUpperLetter;
    } else {
        return @"#";
    }
}
/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
- (NSString *)hanZiToPinYinWithString:(NSString *)hanZi {
    if (!hanZi) {
        return nil;
    }
    NSString *pinYinResult = [NSString string];
    for (int j = 0; j < hanZi.length; j++) {
        NSString *singlePinyinLetter = nil;
        if ([self isChinese:[hanZi substringWithRange:NSMakeRange(j, 1)]]) {
            singlePinyinLetter =
            [[NSString stringWithFormat:@"%c", pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
        } else {
            singlePinyinLetter = [hanZi substringWithRange:NSMakeRange(j, 1)];
        }
        
        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}
- (BOOL)isChinese:(NSString *)text {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:text];
}
- (void)setUpView {
    [self.friendsTabelView
     setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.friendsTabelView];
    [self.view addSubview:self.searchFriendsBar];
}
-(void)loadData:(NSString *)url{
    NSMutableArray * arr = [NSMutableArray array];
    [YSNetworkTool POST:url params:@{} showHud:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        for (int i=0; i<[responseObject[@"data"] count]; i++) {
            ShoolOREduMo * mo = [ShoolOREduMo mj_objectWithKeyValues:responseObject[@"data"][i]];
            [arr addObject:mo];
        }
        self.data_arr = arr;
        [self getAllFriendList:arr];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (UISearchBar *)searchFriendsBar {
    if (!_searchFriendsBar) {
        _searchFriendsBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 0, kScreenWidth - 4, 28)];
        [_searchFriendsBar sizeToFit];
        [_searchFriendsBar setPlaceholder:@"请输入搜索内容"];
        [_searchFriendsBar.layer setBorderWidth:0.5];
        [_searchFriendsBar.layer
         setBorderColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1].CGColor];
        [_searchFriendsBar setDelegate:self];
        [_searchFriendsBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchFriendsBar;
}
- (RCDTableView *)friendsTabelView {
    if (!_friendsTabelView) {
        CGRect searchBarFrame = self.searchFriendsBar.frame;
        CGFloat originY = CGRectGetMaxY(searchBarFrame);
        _friendsTabelView = [[RCDTableView alloc]
                             initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - searchBarFrame.size.height)
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
@end
