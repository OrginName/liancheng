//
//  JFCityViewController.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityViewController.h"

#import "JFCityTableViewCell.h"
#import "JFCityHeaderView.h"
#import "JFAreaDataManager.h"
#import "JFLocation.h"
#import "JFSearchView.h"
#import "YSNetworkTool.h"
#import "CityMo.h"
#define kCurrentCityInfoDefaults [NSUserDefaults standardUserDefaults]
/** 当前屏幕宽度 */
#define kScreenWidth       [UIScreen mainScreen].bounds.size.width
/** 当前屏幕高度 */
#define kScreenHeight      [UIScreen mainScreen].bounds.size.height
@interface JFCityViewController ()
<UITableViewDelegate,
UITableViewDataSource,
JFLocationDelegate,
JFSearchViewDelegate,UITextFieldDelegate>

{
    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
    NSInteger        _HeaderSectionTotal;           //头section的个数
    CGFloat          _cellHeight;                   //添加的(显示区县名称)cell的高度
}
@property (nonatomic,strong) UIView * view_Bottom;
@property (nonatomic,strong) UITextField * search_text;
@property (nonatomic,strong) UIView * view_Search;
@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) JFCityTableViewCell *cell;
@property (nonatomic, strong) JFCityHeaderView *headerView;
@property (nonatomic, strong) JFAreaDataManager *manager;
@property (nonatomic, strong) JFLocation *locationManager;
@property (nonatomic, strong) JFSearchView *searchView;
/** 最近访问的城市*/
@property (nonatomic, strong) NSMutableArray *historyCityMutableArray;
/** 热门城市*/
@property (nonatomic, strong) NSArray *hotCityArray;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;
/** 所有“市”级城市名称*/
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
/** 根据cityNumber在数据库中查到的区县*/
@property (nonatomic, strong) NSMutableArray *areaMutableArray;

@end

@implementation JFCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    _HeaderSectionTotal = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCityWithName:) name:JFCityTableViewCellDidChangeCityNotification object:nil];
    self.view_Bottom = [[UIView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, kScreenHeight-20)];
    [self.view addSubview:self.view_Bottom];
    
    [self.view_Bottom addSubview:self.rootTableView];
    self.rootTableView.tableHeaderView = self.headerView;
    
    [self backBarButtonItem];
//    [self initWithJFAreaDataManaager];
    self.navigationItem.titleView = self.view_Search;
    _indexMutableArray = [NSMutableArray array];
    _sectionMutableArray = [NSMutableArray array];
    _cityMutableArray = [NSMutableArray array];
    
    self.historyCityMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"historyCity"]];
    [self initData];//加载初始化数据
}

/**
 初始化加载城市数据
 */
-(void)initData{
    if ([kCurrentCityInfoDefaults objectForKey:@"cityData"]) {
            self.characterMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"cityData"]];
            _sectionMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[kCurrentCityInfoDefaults objectForKey:@"sectionData"]];
            [_rootTableView reloadData];
        }else {
            [YSNetworkTool POST:dictionaryAreaTreeList params:@{} showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                [_cityMutableArray removeAllObjects];
                for (int i=0; i<[responseObject[@"data"] count]; i++) {
                    CityMo * mo = [CityMo mj_objectWithKeyValues:responseObject[@"data"][i]];
                    mo.ID = responseObject[@"data"][i][@"id"];
                    if (![mo.fullName containsString:@"市"]) {
                        for (int j=0; j<[mo.childs count]; j++) {
                            CityMo * mo1 = [CityMo mj_objectWithKeyValues:mo.childs[j]];
                            mo1.ID = mo.childs[j][@"id"];
                            [_cityMutableArray addObject:mo1];
                        }
                    }else{
                        [_cityMutableArray addObject:mo];
                    }
                }
                [self processData:^(id success) {
                    //回到主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_rootTableView reloadData];
                        self.locationManager = [[JFLocation alloc] init];
                        _locationManager.delegate = self;
                    });
                }];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
}
//搜索按钮
-(void)search{
    if (self.search_text.text.length!=0) {
        [_manager searchCityData:self.search_text.text result:^(NSMutableArray *result) {
            if ([result count] > 0) {
                _searchView.backgroundColor = [UIColor whiteColor];
                _searchView.resultMutableArray = result;
            }
        }];
    }
}
- (void)backBarButtonItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backrootTableViewController) image:@"Arrow-xia" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"search" title:@"" EdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
}
-(void)backrootTableViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/// 初始化数据库，获取所有“市”级城市名称
- (void)initWithJFAreaDataManaager {
    _manager = [JFAreaDataManager shareInstance];
    [_manager areaSqliteDBData];
    __weak typeof(self) weakSelf = self;
    [_manager cityData:^(NSMutableArray *dataArray) {
        //立刻生成一个strong引用，以保证实例在执行期间持续存活
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.cityMutableArray = dataArray;
        }
    }];
}

/// 选择城市时调用通知函数（前提是点击cell的section < 3）
- (void)chooseCityWithName:(NSNotification *)info {
    NSDictionary *cityDic = info.userInfo;
    NSString *cityName = [[NSString alloc] init];
    if ([[cityDic valueForKey:@"cityName"] isEqualToString:@"全城"]) {
        __weak typeof(self) weakSelf = self;
        [_manager currentCity:[kCurrentCityInfoDefaults objectForKey:@"cityNumber"] currentCityName:^(NSString *name) {
            [kCurrentCityInfoDefaults setObject:name forKey:@"currentCity"];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.headerView.cityName = name;
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(cityName:)]) {
                    [strongSelf.delegate cityName:name];
                }
            }

        }];
    }else {
        cityName = [cityDic valueForKey:@"cityName"];
        _headerView.cityName = cityName;
        [kCurrentCityInfoDefaults setObject:[cityDic valueForKey:@"cityName"] forKey:@"currentCity"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
            [self.delegate cityName:cityName];
        }
        [_manager cityNumberWithCity:[cityDic valueForKey:@"cityName"] cityNumber:^(NSString *cityNumber) {
            [kCurrentCityInfoDefaults setObject:cityNumber forKey:@"cityNumber"];
        }];
        
        [self historyCity:cityName];
    }
    
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)areaMutableArray {
    if (!_areaMutableArray) {
        _areaMutableArray = [NSMutableArray arrayWithObject:@"全城"];
    }
    return _areaMutableArray;
}

- (JFCityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JFCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.buttonTitle = @"选择区县";
        _headerView.cityName = [kCurrentCityInfoDefaults objectForKey:@"currentCity"] ? [kCurrentCityInfoDefaults objectForKey:@"currentCity"] : [kCurrentCityInfoDefaults objectForKey:@"locationCity"];
    }
    return _headerView;
}

- (JFSearchView *)searchView {
    if (!_searchView) {
         _searchView = [[JFSearchView alloc] initWithFrame:CGRectMake(0, 0, self.view_Bottom.width, self.view_Bottom.height)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.delegate = self;
    }
    return _searchView;
}

/// 移除搜索界面
- (void)deleteSearchView {
    [_searchView removeFromSuperview];
    _searchView = nil;
}

- (NSMutableArray *)historyCityMutableArray {
    if (!_historyCityMutableArray) {
        _historyCityMutableArray = [[NSMutableArray alloc] init];
    }
    return _historyCityMutableArray;
}

- (NSArray *)hotCityArray {
    if (!_hotCityArray) {
        _hotCityArray = @[@"北京市", @"上海市", @"广州市", @"深圳市", @"武汉市", @"天津市"];
    }
    return _hotCityArray;
}

- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray arrayWithObjects:@"!", nil];
    }
    return _characterMutableArray;
}
/// 汉字转拼音再转成汉字
-(void)processData:(void (^) (id))success{
    for (int i=0; i<_cityMutableArray.count; i++) {
        CityMo * mo = _cityMutableArray[i];
        if (mo.initial.length) {
            //字符串截取第一位，并转换成大写字母
            NSString *firstStr = mo.initial;
            //如果不是字母开头的，转为＃
            BOOL isLetter = [self matchLetter:firstStr];
            if (!isLetter)
                firstStr = @"#";
            //如果还没有索引
            if (_indexMutableArray.count <= 0) {
                //保存当前这个做索引
                [_indexMutableArray addObject:firstStr];
                //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                NSMutableArray *array = [NSMutableArray arrayWithObject:mo];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                [_sectionMutableArray addObject:dic];
            }else{
                //如果索引里面包含了当前这个字母，直接保存数据
                if ([_indexMutableArray containsObject:firstStr]) {
                    //取索引对应的数组，保存当前标题到数组里面
                    NSMutableArray *array = _sectionMutableArray[0][firstStr];
                    [array addObject:mo];
                    //重新保存数据
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [_sectionMutableArray addObject:dic];
                }else{
                    //如果没有包含，说明是新的索引
                    [_indexMutableArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:mo];
                    NSMutableDictionary *dic = _sectionMutableArray[0];
                    [dic setObject:array forKey:firstStr];
                    [_sectionMutableArray addObject:dic];
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
    
    //拼音转换太耗时，这里把第一次转换结果存到单例中
    [kCurrentCityInfoDefaults setValue:cityData forKey:@"cityData"];
    [kCurrentCityInfoDefaults setObject:sectionData forKey:@"sectionData"];
    success(@"成功");
}
///// 汉字转拼音再转成汉字
//-(void)processData:(void (^) (id))success {
//    for (int i = 0; i < _cityMutableArray.count; i ++) {
//        NSString *str = _cityMutableArray[i]; //一开始的内容
//        if (str.length) {  //下面那2个转换的方法一个都不能少
//            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
//            //汉字转拼音
//            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
//            }
//            //拼音转英文
//            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
//                //字符串截取第一位，并转换成大写字母
//                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
//                //如果不是字母开头的，转为＃
//                BOOL isLetter = [self matchLetter:firstStr];
//                if (!isLetter)
//                    firstStr = @"#";
//
//                //如果还没有索引
//                if (_indexMutableArray.count <= 0) {
//                    //保存当前这个做索引
//                    [_indexMutableArray addObject:firstStr];
//                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
//                    NSMutableArray *array = [NSMutableArray arrayWithObject:str];
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
//                    [_sectionMutableArray addObject:dic];
//                }else{
//                    //如果索引里面包含了当前这个字母，直接保存数据
//                    if ([_indexMutableArray containsObject:firstStr]) {
//                        //取索引对应的数组，保存当前标题到数组里面
//                        NSMutableArray *array = _sectionMutableArray[0][firstStr];
//                        [array addObject:str];
//                        //重新保存数据
//                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
//                        [_sectionMutableArray addObject:dic];
//                    }else{
//                        //如果没有包含，说明是新的索引
//                        [_indexMutableArray addObject:firstStr];
//                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
//                        NSMutableArray *array = [NSMutableArray arrayWithObject:str];
//                        NSMutableDictionary *dic = _sectionMutableArray[0];
//                        [dic setObject:array forKey:firstStr];
//                        [_sectionMutableArray addObject:dic];
//                    }
//                }
//            }
//        }
//    }
//
//    //将字母排序
//    NSArray *compareArray = [[_sectionMutableArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    _indexMutableArray = [NSMutableArray arrayWithArray:compareArray];
//
//    //判断第一个是不是字母，如果不是放到最后一个
//    BOOL isLetter = [self matchLetter:_indexMutableArray[0]];
//    if (!isLetter) {
//        //获取数组的第一个元素
//        NSString *firstStr = [_indexMutableArray firstObject];
//        //移除第一项元素
//        [_indexMutableArray removeObjectAtIndex:0];
//        //插入到最后一个位置
//        [_indexMutableArray insertObject:firstStr atIndex:_indexMutableArray.count];
//    }
//
//    [self.characterMutableArray addObjectsFromArray:_indexMutableArray];
//    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:self.characterMutableArray];
//    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:_sectionMutableArray];
//
//    //拼音转换太耗时，这里把第一次转换结果存到单例中
//    [kCurrentCityInfoDefaults setValue:cityData forKey:@"cityData"];
//    [kCurrentCityInfoDefaults setObject:sectionData forKey:@"sectionData"];
//    success(@"成功");
//}

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

-(UIView *)view_Search{
    if (!_view_Search) {
        _view_Search = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _view_Search.backgroundColor = [UIColor whiteColor];
        _search_text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-150, 30)];
        _search_text.backgroundColor = [UIColor whiteColor];
        _search_text.placeholder = @"   请输入城市名称";
        _search_text.font = [UIFont systemFontOfSize:14];
        _search_text.delegate = self;
        [_view_Search addSubview:_search_text];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(_search_text.width+20, 10,10, 10)];
        [btn addTarget:self action:@selector(deleteSearch) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_view_Search addSubview:btn];
    }
    return _view_Search;
}

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:self.view_Bottom.bounds style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.backgroundColor = [UIColor clearColor];
        _rootTableView.sectionIndexColor = [UIColor colorWithRed:0/255.0f green:132/255.0f blue:255/255.0f alpha:1];
        [_rootTableView registerClass:[JFCityTableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityNameCell"];
    }
    return _rootTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _characterMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < _HeaderSectionTotal ? 1 : [_sectionMutableArray[0][_characterMutableArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        if (indexPath.section == _HeaderSectionTotal - 1) {
            _cell.cityNameArray = self.hotCityArray;
        }
    return _cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
        CityMo * mo = currentArray[indexPath.row];
        cell.textLabel.text = mo.fullName;
        cell.textLabel.textColor = KFontColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
        return _cellHeight;
    }else {
        return indexPath.section == (_HeaderSectionTotal - 1) ? _hotCityArray.count/3==0?_hotCityArray.count/3*38:(_hotCityArray.count/3+1)*38 : 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_HeaderSectionTotal == 4 && section == 0) {
        return 0;
    }else{
        return 40;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor =  kCommonBGColor;
    if(section==0){
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        image.image = [UIImage imageNamed:@"city"];
        [view addSubview:image];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 70, 40)];
        lab.text = @"热门城市";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor hexColorWithString:@"#989898"];
        [view addSubview:lab];
        
    }else{
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 40)];
        lab.text = _characterMutableArray[section];
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = [UIColor hexColorWithString:@"#989898"];
        [view addSubview:lab];
    }
    return view;
}
//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _characterMutableArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _headerView.cityName = cell.textLabel.text;
    [kCurrentCityInfoDefaults setObject:cell.textLabel.text forKey:@"currentCity"];
    [_manager cityNumberWithCity:cell.textLabel.text cityNumber:^(NSString *cityNumber) {
        [kCurrentCityInfoDefaults setObject:cityNumber forKey:@"cityNumber"];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:cell.textLabel.text];
    }
    [self historyCity:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self deleteSearchView];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self.view_Bottom addSubview:self.searchView];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_manager searchCityData:textField.text result:^(NSMutableArray *result) {
        if ([result count] > 0) {
            _searchView.backgroundColor = [UIColor whiteColor];
            _searchView.resultMutableArray = result;
        }
    }];
    return YES;
}
//搜索框删除按钮
-(void)deleteSearch{
    self.search_text.text = @"";
    [self deleteSearchView];
}
#pragma mark --- JFCityHeaderViewDelegate

- (void)cityNameWithSelected:(BOOL)selected {
    //获取当前城市的所有辖区
    if (selected) {
        [_manager areaData:[kCurrentCityInfoDefaults objectForKey:@"cityNumber"] areaData:^(NSMutableArray *areaData) {
            [self.areaMutableArray addObjectsFromArray:areaData];
            if (0 == (self.areaMutableArray.count % 3)) {
                _cellHeight = self.areaMutableArray.count / 3 * 50;
            }else {
                _cellHeight = (self.areaMutableArray.count / 3 + 1) * 50;
            }
            if (_cellHeight > 300) {
                _cellHeight = 300;
            }
        }];
        
        //添加一行cell
        [_rootTableView endUpdates];
        [_characterMutableArray insertObject:@"*" atIndex:0];
        _HeaderSectionTotal = 4;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.rootTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [_rootTableView endUpdates];
    }else {
        //清空区县名称数组
        self.areaMutableArray = nil;
        //删除一行cell
        [_rootTableView endUpdates];
        [_characterMutableArray removeObjectAtIndex:0];
        _HeaderSectionTotal = 3;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.rootTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [_rootTableView endUpdates];
    }
}



#pragma mark - JFSearchViewDelegate

- (void)searchResults:(NSDictionary *)dic {
    [kCurrentCityInfoDefaults setObject:[dic valueForKey:@"city"] forKey:@"currentCity"];
    [kCurrentCityInfoDefaults setObject:[dic valueForKey:@"city_number"] forKey:@"cityNumber"];
    NSString *nameStr = [dic valueForKey:@"city"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityName:)]) {
        [self.delegate cityName:nameStr];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self historyCity:[dic valueForKey:@"city"]];
}

- (void)touchViewToExit {
    [_headerView cancelSearch];
}

#pragma mark - JFLocationDelegate

- (void)locating {
    NSLog(@"定位中。。。");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    [kCurrentCityInfoDefaults setObject:city forKey:@"locationCity"];
    [_manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
        [kCurrentCityInfoDefaults setObject:cityNumber forKey:@"cityNumber"];
    }];
    _headerView.cityName = city;
    [self historyCity:city];
    [_rootTableView reloadData];
}

/// 添加历史访问城市
- (void)historyCity:(NSString *)city {
    //避免重复添加，先删除再添加
    [_historyCityMutableArray removeObject:city];
    [_historyCityMutableArray insertObject:city atIndex:0];
    if (_historyCityMutableArray.count > 3) {
        [_historyCityMutableArray removeLastObject];
    }
    NSData *historyCityData = [NSKeyedArchiver archivedDataWithRootObject:self.historyCityMutableArray];
    [kCurrentCityInfoDefaults setObject:historyCityData forKey:@"historyCity"];
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"JFCityViewController dealloc");
}


@end
