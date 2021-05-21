//
//  SNCountryCityNameHandle.h
//  Video
//
//  Created by hexs on 2021/4/6.
//  Copyright © 2021 cnest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCountryCityNameHandle : NSObject

@property (class, strong, readonly) SNCountryCityNameHandle *sharedInstance;

- (NSString *)getFullCityNameWithlocationCode:(NSString *)locationCode;
- (NSString *)getCountryCityNameWithlocationCode:(NSString *)locationCode;

@end

NS_ASSUME_NONNULL_END
