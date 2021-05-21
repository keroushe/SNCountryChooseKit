//
//  SNCountryListData.m
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCountryListData.h"

@implementation SNCountryListCchildsData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _index = -1;
    }
    return self;
}

@end

@implementation SNCountryListPchildsData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _index = -1;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [SNCountryListCchildsData class]};
}

@end

@implementation SNCountryListClistData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _index = -1;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [SNCountryListPchildsData class]};
}

@end

@implementation SNCountryListCountryData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _index = -1;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [SNCountryListClistData class]};
}

@end

@implementation SNCountryListData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _index = -1;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [SNCountryListCountryData class]};
}

// 根据国家code得到国家信息
- (SNCountryListCountryData *)getCountryInfoWithcode:(NSString *)code index:(int *)index
{
    if (code.length <= 0)
    {
        return nil;
    }
    
    SNCountryListCountryData *countryData = nil;
    SNCountryListCountryData *tmpData = nil;
    
    for (int i = 0; i < self.list.count; ++i)
    {
        tmpData = self.list[i];
        if ([tmpData.code isEqualToString:code])
        {
            countryData = tmpData;
            if (index != nil)
            {
                *index = i;
            }
            break;
        }
    }
    
    return countryData;
}

@end
