//
//  SNCountryListData.h
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SNCountryListDataProtocol <NSObject>
/* 名称 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone_code;
/* 列表 */
@property (nonatomic, strong) NSArray<id<SNCountryListDataProtocol>> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

@end

// 区信息
@interface SNCountryListCchildsData : NSObject<SNCountryListDataProtocol>

/* 区名称 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone_code;
/* 列表 */
@property (nonatomic, strong, nullable) NSArray<id<SNCountryListDataProtocol>> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

@end

// 市信息
@interface SNCountryListPchildsData : NSObject<SNCountryListDataProtocol>

/* 市名称 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone_code;
/* 区列表 */
@property (nonatomic, strong) NSArray<SNCountryListCchildsData *> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

@end

// 省信息
@interface SNCountryListClistData : NSObject<SNCountryListDataProtocol>

/* 省名称 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone_code;
/* 市列表 */
@property (nonatomic, strong) NSArray<SNCountryListPchildsData *> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

@end

// 国家信息
@interface SNCountryListCountryData : NSObject<SNCountryListDataProtocol>

/* 国家名称 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone_code;
/* 国家下的省列表 */
@property (nonatomic, strong) NSArray<SNCountryListClistData *> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

@end

// 国家列表
@interface SNCountryListData : NSObject

@property (nonatomic, strong) NSArray<SNCountryListCountryData *> *list;
/* 选中的index,-1代表尚未选择 */
@property (nonatomic, assign) int index;

// 根据国家code得到国家信息
- (SNCountryListCountryData *)getCountryInfoWithcode:(NSString *)code index:(int *)index;

@end

NS_ASSUME_NONNULL_END
