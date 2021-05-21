//
//  SNCountryCodeFlagManage.h
//  Video
//
//  Created by hexs on 2021/1/27.
//  Copyright © 2021 cnest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 国旗获取
@interface SNCountryCodeFlagManage : NSObject

@property (class, strong, readonly) SNCountryCodeFlagManage *sharedInstance;

// 获取国家对应的国旗url
- (NSString *)getCountryFlagUrl:(NSString *)countryCode ResourceFolderUrl:(NSString *)resourceFolderUrl;

@end

NS_ASSUME_NONNULL_END
