//
//  KHLocationInfo.m
//  Video
//
//  Created by hexs on 2021/1/29.
//  Copyright © 2021 cnest. All rights reserved.
//

#import "KHLocationInfo.h"

@implementation KHLocationInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"text = %@.%@.%@.%@, code = %@.%@.%@.%@, phone_code = %@, latitude = %f, longitude = %f", _countryText, _proviceText, _cityText, _areaText, _countryCode, _proviceCode, _cityCode, _areaCode, _phone_code, _latitude, _longitude];
}

@end
