//
//  KHLocationInfo.h
//  Video
//
//  Created by hexs on 2021/1/29.
//  Copyright © 2021 cnest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 选择位置信息
@interface KHLocationInfo : NSObject

@property (nonatomic, copy) NSString *countryText;
@property (nonatomic, copy) NSString *proviceText;
@property (nonatomic, copy) NSString *cityText;
@property (nonatomic, copy) NSString *areaText;

@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *proviceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *areaCode;

@property (nonatomic, copy) NSString *phone_code;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

NS_ASSUME_NONNULL_END
