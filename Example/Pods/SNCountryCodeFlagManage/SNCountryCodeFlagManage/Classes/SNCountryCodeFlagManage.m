//
//  SNCountryCodeFlagManage.m
//  Video
//
//  Created by hexs on 2021/1/27.
//  Copyright © 2021 cnest. All rights reserved.
//

#import "SNCountryCodeFlagManage.h"
#import "NSBundle+SNCountryCode.h"

@interface SNCountryCodeFlagManage ()

/** 支持的国旗列表 */
@property (nonatomic, strong) NSArray *supportFlagList;
/** 国家->邮编规则对应表 */
@property (nonatomic, strong) NSDictionary *regexesRuleMap;

@end

@implementation SNCountryCodeFlagManage

+ (SNCountryCodeFlagManage *)sharedInstance
{
    static SNCountryCodeFlagManage *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[SNCountryCodeFlagManage alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *listfilepath = [[NSBundle sn_CountryCodeBundle] pathForResource:@"country-flag-list.json" ofType:nil];
        NSData *listdata = [NSData dataWithContentsOfFile:listfilepath];
        NSArray *listrootArray = [NSJSONSerialization JSONObjectWithData:listdata options:NSJSONReadingFragmentsAllowed error:nil];
        _supportFlagList = listrootArray;
    }
    return self;
}

// 获取国家对应的国旗url
- (NSString *)getCountryFlagUrl:(NSString *)countryCode ResourceFolderUrl:(NSString *)resourceFolderUrl
{
    if (countryCode.length <= 0)
    {
        return nil;
    }
    
    // 判断countryCode是否存在列表中
    if (![_supportFlagList containsObject:countryCode])
    {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@.png", resourceFolderUrl, countryCode];
}

@end
