//
//  SNCityCListVC.m
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCityCListVC.h"
#import <Masonry/Masonry.h>
#import "SNCountryListHeaderView.h"
#import "NSString+SNCountryChoose.h"

@interface SNCityCListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 分组的字典数据 内容数据源 */
@property (nonatomic,strong) NSMutableDictionary *dataSourceDictionary;
/** 分组的字典数据 标题头数据源*/
@property (nonatomic,strong) NSMutableDictionary *dataSourceTitleDictionary;
/** 分组标题数据集合 -- 已经排好序的 */
@property (nonatomic,strong) NSMutableArray *titleSourtArray;

@end

@implementation SNCityCListVC
static NSString *const SNCountryListHeaderViewIdentifier = @"SNCountryListHeaderViewIdentifier";

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _tableView.rowHeight = 50;
        _tableView.sectionIndexColor = [UIColor colorWithRed:0x45/255.0 green:0x82/255.0 blue:0xD6/255.0 alpha:1.0];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[SNCountryListHeaderView class] forHeaderFooterViewReuseIdentifier:SNCountryListHeaderViewIdentifier];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.dataInfo.name;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self startLoadData];
}

- (void)startLoadData
{
    /** 分组的字典数据 内容数据源 */
    _dataSourceDictionary = [[NSMutableDictionary alloc] init];
    /** 分组的字典数据 标题头数据源*/
    _dataSourceTitleDictionary = [[NSMutableDictionary alloc] init];
    /** 分组标题数据集合 -- 已经排好序的 */
    _titleSourtArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 将数据进行排序分组
        [self transferDataSource:self.dataInfo.list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleSourtArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

// 显示每组标题索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleSourtArray;
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
    
    view.titleLabel.text = self.titleSourtArray[section];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.titleSourtArray.count)
    {
        return 0;
    }
    
    NSArray *rowArray = [self.dataSourceTitleDictionary objectForKey:self.titleSourtArray[section]];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const countryCellIdentifier = @"countryCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countryCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:countryCellIdentifier];
    }
    
    if (indexPath.section >= self.titleSourtArray.count)
    {
        return cell;
    }
    
    NSString *headTitle = self.titleSourtArray[indexPath.section];
    NSArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headTitle];
    
    if (indexPath.row >= dataSourceArray.count)
    {
        return cell;
    }
    
    id<SNCountryListDataProtocol> data = dataSourceArray[indexPath.row];
    if (data.list.count > 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0f];
    cell.textLabel.text = data.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section >= self.titleSourtArray.count) return;
    
    NSString *headTitle = self.titleSourtArray[indexPath.section];
    NSArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headTitle];
    
    if (indexPath.row >= dataSourceArray.count) return;
    
    id<SNCountryListDataProtocol> data = dataSourceArray[indexPath.row];
    self.dataInfo.index = (int)[self.dataInfo.list indexOfObject:data];
    
    if (data.list.count > 0)
    {
        // 进入下一级界面
        SNCityCListVC *cityVC = [[SNCityCListVC alloc] init];
        cityVC.chooseCityCompletion = self.chooseCityCompletion;
        cityVC.chooseInfo = self.chooseInfo;
        cityVC.dataInfo = data;
        [self.navigationController pushViewController:cityVC animated:YES];
    }
    else
    {
        // 修改为选中
        id<SNCountryListDataProtocol> countryInfo = nil;
        id<SNCountryListDataProtocol> cNameInfo = nil;
        id<SNCountryListDataProtocol> pcNameInfo = nil;
        id<SNCountryListDataProtocol> ccNameInfo = nil;
        
        if (self.chooseInfo.index >= 0)
        {
            countryInfo = self.chooseInfo.list[self.chooseInfo.index];
            // 判断如果选中为第0项，而且当前列表中只有一项，则不进行相应处理, 直接进入下一级
            if (countryInfo.index >= 0)
            {
                cNameInfo = countryInfo.list[countryInfo.index];
                if (cNameInfo.index >= 0)
                {
                    pcNameInfo = cNameInfo.list[cNameInfo.index];
                    if (pcNameInfo.index)
                    {
                        ccNameInfo = pcNameInfo.list[pcNameInfo.index];
                    }
                }
            }
        }
        NSLog(@"country = %@, cName = %@, pcName = %@, ccName = %@", countryInfo.name, cNameInfo.name, pcNameInfo.name, ccNameInfo.name);
        
        KHLocationInfo *locationInfo = [[KHLocationInfo alloc] init];
        locationInfo.countryText = countryInfo.name;
        locationInfo.proviceText = cNameInfo.name;
        locationInfo.cityText = pcNameInfo.name;
        locationInfo.areaText = ccNameInfo.name;
        
        locationInfo.countryCode = countryInfo.code;
        locationInfo.proviceCode = cNameInfo.code;
        locationInfo.cityCode = pcNameInfo.code;
        locationInfo.areaCode = ccNameInfo.code;
        
        locationInfo.phone_code = countryInfo.phone_code;
        
        [self chooseFinishedWithlocationInfo:locationInfo];
    }
}

#pragma mark 数据源转换
/**
 *  数据源转换成分组的数据
 */
- (void)transferDataSource:(NSArray<id<SNCountryListDataProtocol>> *)dataSourceArray
{
    NSMutableArray *titleSortArray = [NSMutableArray array];
    [dataSourceArray enumerateObjectsUsingBlock:^(id<SNCountryListDataProtocol> dataInfo, NSUInteger index, BOOL * _Nonnull stop) {
        
        // 取得字符串首字母
        NSString *headerString = [NSString sn_getFirstLetter:dataInfo.name];
        // 字符只取字母,其他都用#代替
        if (![headerString sn_isOnlyLatter]) {
            headerString = @"#";
        }
        
        NSMutableArray *headerArray = [self.dataSourceTitleDictionary objectForKey:headerString];
        NSMutableArray *dataSourceArray = [self.dataSourceDictionary objectForKey:headerString];
        if (headerArray == nil)
        {
            [self.dataSourceTitleDictionary setObject:[NSMutableArray arrayWithObject:dataInfo.name] forKey:headerString];
            [self.dataSourceDictionary setObject:[NSMutableArray arrayWithObject:dataInfo] forKey:headerString];
        }
        else
        {
            //设置分组数据
            [headerArray addObject:dataInfo.name];
            [self.dataSourceTitleDictionary setObject:headerArray forKey:headerString];
            
            // 设置内容数据
            [dataSourceArray addObject:dataInfo];
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
