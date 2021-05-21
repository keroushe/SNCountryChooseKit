//
//  SNCountryCityNameHandle.m
//  Video
//
//  Created by hexs on 2021/4/6.
//  Copyright © 2021 cnest. All rights reserved.
//

#import "SNCountryCityNameHandle.h"
#import "SNCountryChooseLanHandle.h"
#import "NSBundle+SNCountryChoose.h"

@interface SNCountryCityNameHandle ()

@property (nonatomic, strong) NSDictionary *cityMapDict;

@end

@implementation SNCountryCityNameHandle

+ (SNCountryCityNameHandle *)sharedInstance
{
    static SNCountryCityNameHandle *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[SNCountryCityNameHandle alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self asyncLoadMapFile];
    }
    return self;
}

- (void)asyncLoadMapFile
{
    NSString *filepath = [[NSBundle sn_countryChooseBundle] pathForResource:[NSString stringWithFormat:@"mapfile/dict_city_list_%@.json", SNCountryChooseLanHandle.sharedInstance.curLan] ofType:nil];
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
    _cityMapDict = rootDict;
}

- (NSString *)getFullCityNameWithlocationCode:(NSString *)locationCode
{
    if (locationCode == nil || locationCode.length <= 0)
    {
        return nil;
    }
    NSArray<NSString *> *codeArray = [locationCode componentsSeparatedByString:@"."];
    if (codeArray.count >= 1)
    {
        NSMutableString *locationStr = [[NSMutableString alloc] init];
        // 国家
        NSString *countryCode = codeArray[0];
        NSString *countryStr = _cityMapDict[countryCode];
        if (countryStr.length > 0)
        {
            [locationStr appendString:countryStr];
        }
        
        if (codeArray.count >= 2)
        {
            // 省
            NSString *proviceCode = codeArray[1];
            NSString *proviceStr = _cityMapDict[proviceCode];
            if (proviceStr.length > 0)
            {
                [locationStr appendFormat:@".%@", proviceStr];
            }
            
            if (codeArray.count >= 3)
            {
                // 市
                NSString *cityCode = codeArray[2];
                NSString *cityStr = _cityMapDict[cityCode];
                if (cityStr.length > 0)
                {
                    [locationStr appendFormat:@".%@", cityStr];
                }
            }
        }
        
        return locationStr;
    }
    
    return nil;
}

- (NSString *)getCountryCityNameWithlocationCode:(NSString *)locationCode
{
    if (locationCode == nil || locationCode.length <= 0)
    {
        return nil;
    }
    NSArray<NSString *> *codeArray = [locationCode componentsSeparatedByString:@"."];
    if (codeArray.count >= 1)
    {
        NSMutableString *locationStr = [[NSMutableString alloc] init];
        // 国家
        NSString *countryCode = codeArray[0];
        NSString *countryStr = _cityMapDict[countryCode];
        if (countryStr.length > 0)
        {
            [locationStr appendString:countryStr];
        }
        
        if (codeArray.count >= 2)
        {
            // 省
            NSString *proviceCode = codeArray[1];
            NSString *proviceStr = _cityMapDict[proviceCode];
            if (proviceStr.length > 0)
            {
                [locationStr appendFormat:@".%@", proviceStr];
            }
        }
        
        return locationStr;
    }
    
    return nil;
}

@end
