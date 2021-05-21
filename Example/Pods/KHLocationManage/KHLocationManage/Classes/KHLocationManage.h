//
//  KHLocationManage.h
//  KHKit
//
//  Created by hexs on 16/5/10.
//  Copyright © 2016年 hexs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHLocationInfo.h"

@protocol KHLocationManageDelegate <NSObject>
@optional
- (void)getLocationWithInfo:(KHLocationInfo *)locationInfo;
- (void)authorizationDeniedorRestricted;

@end

#define KHLocationManageInstance [KHLocationManage shareKHLocationManage]

/**
 获取位置信息
 注意: 需要添加Info.plist字段,
 NSLocationWhenInUseUsageDescription
 NSLocationAlwaysUsageDescription
 */
@interface KHLocationManage : NSObject

@property (nonatomic,weak) id<KHLocationManageDelegate> delegate;

//创建实例
+ (KHLocationManage *)shareKHLocationManage;

//开始获取地理位置
- (void)startGetLocation;

@end
