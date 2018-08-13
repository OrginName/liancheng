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
#import "JFSearchView.h"
#import "JFAreaDataManager.h"
@interface SortCollProController ()<JFSearchViewDelegate>
{
    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
}
@property (nonatomic,strong) UIView * view_Bottom;
@property(strong, nonatomic) NSMutableArray *matchFriendList;
@property(strong, nonatomic) NSArray *defaultCellsTitle;
@property(strong, nonatomic) NSArray *defaultCellsPortrait;
@property(nonatomic, assign) BOOL hasSyncFriendList;
@property(nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, strong) JFSearchView *searchView;
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (nonatomic,strong) NSMutableArray * data_arr;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;
/** 所有“市”级城市名称*/
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
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
    _indexMutableArray = [NSMutableArray array];
    _sectionMutableArray = [NSMutableArray array];
    _cityMutableArray = [NSMutableArray array];
    _manager = [JFAreaDataManager shareInstance];
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
    [self initData:_url];
}
/**
 初始化加载学校数据
 */
-(void)initData:(NSString *)url{
    if ([KUserDefults objectForKey:@"schollData"]) {
        self.characterMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"schollData"]];
        _sectionMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"sectionData1"]];
        _cityMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefults objectForKey:@"cityData2"]];
        [self.friendsTabelView reloadData];
    }else {
        [YSNetworkTool POST:url params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            for (int i=0; i<[responseObject[@"data"] count]; i++) {
                ShoolOREduMo * mo = [ShoolOREduMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                [_cityMutableArray addObject:mo];
            }
            [self processData:^(id success) {
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.friendsTabelView reloadData];
                });
            }];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
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
//    NSInteger rows = 0;
//    NSString *letter = self.resultDic[@"allKeys"][section];
//    rows = [self.allFriendSectionDic[letter] count];
//    return rows;
    return [_sectionMutableArray[0][_characterMutableArray[section]] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [self.resultDic[@"allKeys"] count];
    return _characterMutableArray.count;
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
    title.text = _characterMutableArray[section];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    UITableViewCell *cell =
    [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
    }
//    NSString *letter = self.resultDic[@"allKeys"][indexPath.section];
    NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
//    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    ShoolOREduMo * shool = currentArray[indexPath.row];
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
    return _characterMutableArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   ShoolOREduMo * mo = _sectionMutableArray[0][_characterMutableArray[indexPath.section]][indexPath.row];
    self.block(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchFriendsBar resignFirstResponder];
}
#pragma mark --------------
-(void)serchResultSchoolMo:(ShoolOREduMo *)mo{
    self.block(mo);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取好友并且排序
//- (void)getAllFriendList:(NSMutableArray *)arr{
//    [self sortAndRefreshWithList:[arr copy]];
//    self.hasSyncFriendList = YES;
//}
//- (void)sortAndRefreshWithList:(NSArray *)friendList {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.resultDic = [self sortedArrayWithPinYinDic:friendList];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.allFriendSectionDic = self.resultDic[@"infoDic"];
//            [self.friendsTabelView reloadData];
//        });
//    });
//}
#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    [self.matchFriendList removeAllObjects];
//    if (searchText.length <= 0) {
////        [self sortAndRefreshWithList:self.data_arr];
//    } else {
//        for (ShoolOREduMo *userInfo in self.data_arr) {
//            //忽略大小写去判断是否包含
////            if ([userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
////                [[self hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText
////                                                                            options:NSCaseInsensitiveSearch]
////                .location != NSNotFound) {
////                [self.matchFriendList addObject:userInfo];
////            }
//        }
////        [self sortAndRefreshWithList:self.matchFriendList];
//    }
    [self.view_Bottom addSubview:self.searchView];
    _manager.dataArr = _cityMutableArray;
    [_manager searchCityData1:searchText result:^(NSMutableArray *result) {
        if ([result count] > 0) {
            _searchView.backgroundColor = [UIColor whiteColor];
            _searchView.resultMutableArray = result;
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchView removeFromSuperview];
    _searchView = nil;
    self.searchFriendsBar.showsCancelButton = NO;
    [self.searchFriendsBar resignFirstResponder];
    self.searchFriendsBar.text = @"";
//    [self.matchFriendList removeAllObjects];
//    [self sortAndRefreshWithList:self.data_arr];
    _isBeginSearch = NO;
//    [self.friendsTabelView reloadData];
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
//- (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList {
//    if (!userList)
//        return nil;
//    NSArray *_keys = @[
//                       @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N",
//                       @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"
//                       ];
//
//    NSMutableDictionary *infoDic = [NSMutableDictionary new];
//    NSMutableArray *_tempOtherArr = [NSMutableArray new];
//    BOOL isReturn = NO;
//    for (NSString *key in _keys) {
//        if ([_tempOtherArr count]) {
//            isReturn = YES;
//        }
//        NSMutableArray *tempArr = [NSMutableArray new];
//        for (id user in userList) {
//            NSString *firstLetter;
//            if ([user isMemberOfClass:[ShoolOREduMo class]]) {
//                ShoolOREduMo *userInfo = (ShoolOREduMo *)user;
//                if (userInfo.name.length > 0 && ![userInfo.name isEqualToString:@""]) {
//                    firstLetter = [self getFirstUpperLetter:userInfo.name];
//                } else {
//                    firstLetter = [self getFirstUpperLetter:userInfo.name];
//                }
//            }
//            if ([firstLetter isEqualToString:key]) {
//                [tempArr addObject:user];
//            }
//
//            if (isReturn)
//                continue;
//            char c = [firstLetter characterAtIndex:0];
//            if (isalpha(c) == 0) {
//                [_tempOtherArr addObject:user];
//            }
//        }
//        if (![tempArr count])
//            continue;
//        [infoDic setObject:tempArr forKey:key];
//    }
//    if ([_tempOtherArr count])
//        [infoDic setObject:_tempOtherArr forKey:@"#"];
//
//    NSArray *keys = [[infoDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:keys];
//
//    NSMutableDictionary *resultDic = [NSMutableDictionary new];
//    [resultDic setObject:infoDic forKey:@"infoDic"];
//    [resultDic setObject:allKeys forKey:@"allKeys"];
//    return resultDic;
//}
//-(NSString *)getFirstUpperLetter:(NSString *)hanzi {
//    NSString *pinyin = [self hanZiToPinYinWithString:hanzi];
//    NSString *firstUpperLetter = [[pinyin substringToIndex:1] uppercaseString];
//    if ([firstUpperLetter compare:@"A"] != NSOrderedAscending &&
//        [firstUpperLetter compare:@"Z"] != NSOrderedDescending) {
//        return firstUpperLetter;
//    } else {
//        return @"#";
//    }
//}
/**
 *  汉字转拼音
 *
 *  @param hanZi 汉字
 *
 *  @return 转换后的拼音
 */
//- (NSString *)hanZiToPinYinWithString:(NSString *)hanZi {
//    if (!hanZi) {
//        return nil;
//    }
//    NSString *pinYinResult = [NSString string];
//    for (int j = 0; j < hanZi.length; j++) {
//        NSString *singlePinyinLetter = nil;
//        if ([self isChinese:[hanZi substringWithRange:NSMakeRange(j, 1)]]) {
//            singlePinyinLetter =
//            [[NSString stringWithFormat:@"%c", pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
//        } else {
//            singlePinyinLetter = [hanZi substringWithRange:NSMakeRange(j, 1)];
//        }
//
//        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
//    }
//    return pinYinResult;
//}
//- (BOOL)isChinese:(NSString *)text {
//    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
//    return [predicate evaluateWithObject:text];
//}
- (void)setUpView {
    [self.friendsTabelView
     setBackgroundColor:[UIColor whiteColor]];
    self.view_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20)];
    [self.view addSubview:self.view_Bottom];
    
    [self.view_Bottom addSubview:self.friendsTabelView];
//    [self.view addSubview:self.friendsTabelView];
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
//        [self getAllFriendList:arr];
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
                             initWithFrame:CGRectMake(0, originY, kScreenWidth, kScreenHeight - searchBarFrame.size.height)
                             style:UITableViewStyleGrouped];
        
//        _friendsTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        if ([_friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
//            _friendsTabelView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
//        }
//        if ([_friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
//            _friendsTabelView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0);
//        }
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
// 汉字转拼音再转成汉字
-(void)processData:(void (^) (id))success {
    for (int i = 0; i < _cityMutableArray.count; i ++) {
        ShoolOREduMo * shool = _cityMutableArray[i];
        NSString *str = shool.name; //一开始的内容
        if (str.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"#";

                //如果还没有索引
                if (_indexMutableArray.count <= 0) {
                    //保存当前这个做索引
                    [_indexMutableArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:shool];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [_sectionMutableArray addObject:dic];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if ([_indexMutableArray containsObject:firstStr]) {
                        //取索引对应的数组，保存当前标题到数组里面
                        NSMutableArray *array = _sectionMutableArray[0][firstStr];
                        [array addObject:shool];
                        //重新保存数据
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [_sectionMutableArray addObject:dic];
                    }else{
                        //如果没有包含，说明是新的索引
                        [_indexMutableArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                        NSMutableArray *array = [NSMutableArray arrayWithObject:shool];
                        NSMutableDictionary *dic = _sectionMutableArray[0];
                        [dic setObject:array forKey:firstStr];
                        [_sectionMutableArray addObject:dic];
                    }
                }
            }
        }
    }

    //将字母排序
    NSArray *compareArray = [[_sectionMutableArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    _indexMutableArray = [NSMutableArray arrayWithArray:compareArray];
   
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:_indexMutableArray[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [_indexMutableArray firstObject];
        //移除第一项元素
        [_indexMutableArray removeObjectAtIndex:0];
        //插入到最后一个位置
        [_indexMutableArray insertObject:firstStr atIndex:_indexMutableArray.count];
    }

    [self.characterMutableArray addObjectsFromArray:_indexMutableArray];
    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:self.characterMutableArray];
    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:_sectionMutableArray];
    NSData * cityData2 = [NSKeyedArchiver archivedDataWithRootObject:self.cityMutableArray];
    //拼音转换太耗时，这里把第一次转换结果存到单例中
    [KUserDefults setValue:cityData forKey:@"schollData"];
    [KUserDefults setObject:sectionData forKey:@"sectionData1"];
    [KUserDefults setObject:cityData2 forKey:@"cityData2"];
    success(@"成功");
}
- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray array];
    }
    return _characterMutableArray;
}
#pragma mark - 匹配是不是字母开头
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
- (JFSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[JFSearchView alloc] initWithFrame:CGRectMake(0, 0, self.view_Bottom.width, self.view_Bottom.height)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.delegate = self;
    }
    return _searchView;
}
@end
