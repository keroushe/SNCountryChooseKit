//
//  SNCountryListVC.m
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCountryListVC.h"
#import <Masonry/Masonry.h>
#import "SNCountryListData.h"
#import "SNCountryListHeaderView.h"
#import "SNCountryListCell.h"
#import "NSBundle+SNCountryChoose.h"
// 定位
#import "KHLocationManage.h"
// 下一级界面
#import "SNCityCListVC.h"
#import "SNCountryChooseLanHandle.h"
#import "NSString+SNCountryChoose.h"
#import <MJExtension/MJExtension.h>

@interface SNCountryListVC ()<UITableViewDataSource, UITableViewDelegate, KHLocationManageDelegate>

@property (nonatomic, strong) UITableView *tableView;
// 定位及头部title
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) SNCountryListData *listData;

/** 分组的字典数据 内容数据源 */
@property (nonatomic,strong) NSMutableDictionary *dataSourceDictionary;
/** 分组的字典数据 标题头数据源*/
@property (nonatomic,strong) NSMutableDictionary *dataSourceTitleDictionary;
/** 分组标题数据集合 -- 已经排好序的 */
@property (nonatomic,strong) NSMutableArray *titleSourtArray;

// 所有的title数组
@property (nonatomic, strong) NSMutableArray<NSString *> *allTitleArray;
// 显示索引title数组
@property (nonatomic, strong) NSMutableArray<NSString *> *indexTitleArray;

// 当前状态: 0. 正在定位，1.定位成功，2.定位失败
@property (nonatomic, assign) int curStatus;
// 定位成功的城市信息
@property (nonatomic, strong) KHLocationInfo *locationInfo;

@end

@implementation SNCountryListVC
static NSString *const SNCountryListHeaderViewIdentifier = @"SNCountryListHeaderViewIdentifier";
static NSString *const SNCountryListCellIdentifier = @"SNCountryListCellIdentifier";

- (NSArray<NSString *> *)titles
{
    if (!_titles)
    {
        _titles = @[SNCountryChooseLanHandle.sharedInstance.keyNewCityChoose_UseCur_Location];
    }
    return _titles;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _tableView.rowHeight = 50;
        _tableView.sectionIndexColor = [UIColor colorWithRed:0x45/255.0 green:0x82/255.0 blue:0xD6/255.0 alpha:1.0];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[SNCountryListHeaderView class] forHeaderFooterViewReuseIdentifier:SNCountryListHeaderViewIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:@"SNCountryListCell" bundle:[NSBundle sn_countryChooseBundle]] forCellReuseIdentifier:SNCountryListCellIdentifier];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = SNCountryChooseLanHandle.sharedInstance.keyNewCityChoose_Title;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    /** 分组的字典数据 内容数据源 */
    _dataSourceDictionary = [[NSMutableDictionary alloc] init];
    /** 分组的字典数据 标题头数据源*/
    _dataSourceTitleDictionary = [[NSMutableDictionary alloc] init];
    /** 分组标题数据集合 -- 已经排好序的 */
    _titleSourtArray = [[NSMutableArray alloc] init];
    _allTitleArray = [[NSMutableArray alloc] init];
    _indexTitleArray = [[NSMutableArray alloc] init];
    
    [self startLoadData];
    // 开始定位
    _curStatus = 0;
    [KHLocationManage shareKHLocationManage].delegate = self;
    [[KHLocationManage shareKHLocationManage] startGetLocation];
}

- (void)startLoadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        NSString *filepath = [[NSBundle sn_countryChooseBundle] pathForResource:[NSString stringWithFormat:@"json/city_list_%@.json", SNCountryChooseLanHandle.sharedInstance.curLan] ofType:nil];
        if (filepath == nil)
        {
            return;
        }
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data == nil)
        {
            return;
        }
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:nil];
        
        self.listData = [SNCountryListData mj_objectWithKeyValues:rootDict];
        
        // 将数据进行排序分组
        [self transferDataSource:self.listData.list];
        // 生成titles
        NSMutableArray<NSString *> *resTitles = [[NSMutableArray alloc] init];
        for (int index = 0; index < self.titles.count; ++index)
        {
            [resTitles addObject:@"#"];
        }
        [self.indexTitleArray addObjectsFromArray:resTitles];
        [self.indexTitleArray addObjectsFromArray:self.titleSourtArray];
        
        [self.allTitleArray addObjectsFromArray:self.titles];
        [self.allTitleArray addObjectsFromArray:self.titleSourtArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

// 显示每组标题索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexTitleArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SNCountryListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SNCountryListHeaderViewIdentifier];
    if (section >= [self numberOfSectionsInTableView:tableView])
    {
        return view;
    }
    
    view.titleLabel.text = self.allTitleArray[section];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果是titles, 则只有一行
    if (section < self.titles.count)
    {
        return 1;
    }
    
    NSArray *rowArray = [self.dataSourceTitleDictionary objectForKey:self.allTitleArray[section]];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.titles.count)
    {
        static NSString *const countryCellIdentifier = @"countryCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countryCellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:countryCellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        if (0 == _curStatus)
        {
            cell.textLabel.text = SNCountryChooseLanHandle.sharedInstance.keyNewCityChoose_Locationing;
        }
        else if (1 == _curStatus)
        {
            cell.textLabel.text = _locationInfo.cityText;
        }
        else
        {
            cell.textLabel.text = SNCountryChooseLanHandle.sharedInstance.keyNewCityChoose_Location_Disable;
            cell.textLabel.textColor = [UIColor colorWithRed:0xE0/255.0f green:0xE0/255.0f blue:0xE0/255.0f alpha:1.0f];
        }
        return cell;
    }
    
    // 数据分组部分
    SNCountryListCell *cell = [tableView dequeueReusableCellWithIdentifier:SNCountryListCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section >= self.allTitleArray.count)
    {
        return cell;
    }
    
    NSString *headTitle = self.allTitleArray[indexPath.section];
    NSArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headTitle];
    
    if (indexPath.row >= dataSourceArray.count)
    {
        return cell;
    }
    
    [cell loadCellData:dataSourceArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section < self.titles.count)
    {
        if (1 == _curStatus)
        {
            // 选中当前定位城市
            [self chooseFinishedWithlocationInfo:_locationInfo];
        }
    }
    else
    {
        if (indexPath.section >= self.allTitleArray.count) return;
        
        NSString *headTitle = self.allTitleArray[indexPath.section];
        NSArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headTitle];
        
        if (indexPath.row >= dataSourceArray.count) return;
        
        SNCountryListCountryData *countryData = dataSourceArray[indexPath.row];
        // TODO:需要处理
        self.listData.index = (int)[self.listData.list indexOfObject:countryData];
        
        if (countryData.list.count > 0)
        {
            // 进入下一级界面
            SNCityCListVC *cityVC = [[SNCityCListVC alloc] init];
            cityVC.chooseCityCompletion = self.chooseCityCompletion;
            cityVC.chooseInfo = self.listData;
            cityVC.dataInfo = countryData;
            [self.navigationController pushViewController:cityVC animated:YES];
        }
        else
        {
            // 修改为选中
            KHLocationInfo *locationInfo = [[KHLocationInfo alloc] init];
            locationInfo.countryText = countryData.name;
            locationInfo.countryCode = countryData.code;
            locationInfo.phone_code = countryData.phone_code;
            
            [self chooseFinishedWithlocationInfo:locationInfo];
        }
    }
}

#pragma mark - <KHLocationManageDelegate>
- (void)getLocationWithInfo:(KHLocationInfo *)locationInfo
{
    _curStatus = 1;
    _locationInfo = locationInfo;
    // 更新
    [self updateLocationRowInfo];
}

- (void)authorizationDeniedorRestricted
{
    _curStatus = 2;
    // 更新
    [self updateLocationRowInfo];
}

- (void)updateLocationRowInfo
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil)
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark 数据源转换
/**
 *  数据源转换成分组的数据
 */
- (void)transferDataSource:(NSArray<SNCountryListCountryData *> *)dataSourceArray
{
    NSMutableArray *titleSortArray = [NSMutableArray array];
    [dataSourceArray enumerateObjectsUsingBlock:^(SNCountryListCountryData *countryInfo, NSUInteger index, BOOL * _Nonnull stop) {
        
        // 取得字符串首字母
        NSString *headerString = [NSString sn_getFirstLetter:countryInfo.name];
        // 字符只取字母,其他都用#代替
        if (![headerString sn_isOnlyLatter]) {
            headerString = @"#";
        }
        
        NSMutableArray *headerArray = [self.dataSourceTitleDictionary objectForKey:headerString];
        NSMutableArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headerString];
        if (headerArray == nil)
        {
            [self.dataSourceTitleDictionary setObject:[NSMutableArray arrayWithObject:countryInfo.name] forKey:headerString];
            [self.dataSourceDictionary setObject:[NSMutableArray arrayWithObject:countryInfo] forKey:headerString];
        }
        else
        {
            //设置分组数据
            [headerArray addObject:countryInfo.name];
            [self.dataSourceTitleDictionary setObject:headerArray forKey:headerString];
            
            // 设置内容数据
            [dataSourceArray addObject:countryInfo];
            [self.dataSourceDictionary setObject:dataSourceArray forKey:headerString];
        }
    }];
    
    [titleSortArray addObjectsFromArray:[self.dataSourceTitleDictionary allKeys]];
    
    // 字符串排序
    NSArray *titlArray = [NSString sn_sortStringFromArray:titleSortArray upOrDown:0];
    NSMutableArray *sortArray = nil;
    if (titlArray.count > 0)
    {
        sortArray = [NSMutableArray arrayWithArray:titlArray];
        NSString *firstString = [sortArray firstObject];
        if ([firstString isEqualToString:@"#"])
        {
            if (sortArray.count) {
                [sortArray removeObjectAtIndex:0];
            }
            [sortArray addObject:firstString];
        }
        [self.titleSourtArray addObjectsFromArray:sortArray];
    }
}

@end
