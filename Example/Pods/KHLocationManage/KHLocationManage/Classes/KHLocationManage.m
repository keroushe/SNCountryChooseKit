//
//  KHLocationManage.m
//  KHKit
//
//  Created by hexs on 16/5/10.
//  Copyright © 2016年 hexs. All rights reserved.
//

#import "KHLocationManage.h"
#import "NSBundle+KHLocationManage.h"
//系统地理位置管理类
#import <CoreLocation/CoreLocation.h>

@implementation NSObject (KHLocationManage)
- (void)getLocationWithproviceText:(NSString *)proviceText cityText:(NSString *)cityText countryText:(NSString *)countryText latitude:(double)latitude longitude:(double)longitude {}
- (void)authorizationDeniedorRestricted {}

@end

@interface KHLocationManage ()<CLLocationManagerDelegate>

// 地理位置获取类
@property (nonatomic,strong) CLLocationManager * mLocationManager;
// 地理坐标与地理位置转换
@property (strong, nonatomic) CLGeocoder * geocoder;
// 国家->电话区号对应表
@property (nonatomic, strong) NSDictionary *countryAndPhoneDict;

@end

@implementation KHLocationManage

//创建实例
+ (KHLocationManage *)shareKHLocationManage
{
    static dispatch_once_t onceToken = 0;
    static KHLocationManage * shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _mLocationManager = [[CLLocationManager alloc] init];
        _geocoder = [[CLGeocoder alloc] init];
        
        NSString *countryPhoneCodefilapath = [[NSBundle kh_locationManageBundle] pathForResource:@"country-phone-code.json" ofType:nil];
        NSData *countryPhoneCodeData = [NSData dataWithContentsOfFile:countryPhoneCodefilapath];
        _countryAndPhoneDict = [NSJSONSerialization JSONObjectWithData:countryPhoneCodeData options:NSJSONReadingFragmentsAllowed error:nil];
    }
    return self;
}

//开始获取地理位置
- (void)startGetLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        _mLocationManager.delegate = self;
        _mLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _mLocationManager.distanceFilter = 100.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
            //请求授权
            [self requestauthorizationStatus];
        } else {
            //开始实时定位
            [_mLocationManager startUpdatingLocation];
        }
    }
}

// 请求授权
- (void)requestauthorizationStatus
{
    //判断当前定位服务授权
    CLAuthorizationStatus currentAuthStatus = [CLLocationManager authorizationStatus];
    switch (currentAuthStatus){
        case kCLAuthorizationStatusRestricted:{
            //已经被用户明确禁止定位
            [_delegate authorizationDeniedorRestricted];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            //未开启授权
            [_delegate authorizationDeniedorRestricted];
            break;
        }
        case kCLAuthorizationStatusNotDetermined:{
            //没有确定授权
            if ([self.mLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.mLocationManager requestWhenInUseAuthorization];
                
            } else if ([self.mLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.mLocationManager requestAlwaysAuthorization];
                
            }
            break;
        }
        default:{
            //已经授权
            [self.mLocationManager startUpdatingLocation];
            break;
        }
    }
}

#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        //获取到地理位置
        CLLocation * currentlocation = locations[0];
        //逆地理解析，经纬度转换成地位位置，国家>省>市>街道
        __weak typeof(self) wself = self;
        [_geocoder reverseGeocodeLocation:currentlocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            __strong typeof(wself) sself = wself;
            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
            if (placemarks.count > 0) {
                // 获取位置之后，停止定位，代理置空
                sself.mLocationManager.delegate = nil;
                [sself.mLocationManager stopUpdatingLocation];
                //地址处理
                CLPlacemark * placemark = [placemarks firstObject];
                //国家.省·市·县区
                NSString *countryText = placemark.country;
                NSString *proviceText = placemark.administrativeArea;
                NSString *cityText = placemark.locality;
                NSString *areaText = placemark.subLocality;
                //
                NSString *addressinfo = [NSString stringWithFormat:@"%@·%@·%@.%@", countryText, proviceText, cityText, areaText];
                NSLog(@"addressinfo = %@",addressinfo);
                // ISOcountryCode
                NSString *countryCode = placemark.ISOcountryCode;
                NSLog(@"countryCode = %@", countryCode);
                // 国家电话区号
                NSString *phone_code = nil;
                if (countryCode != nil)
                {
                    phone_code = self.countryAndPhoneDict[countryCode];
                }
                NSLog(@"phone_code = %@", phone_code);
                
                //经纬度
                double latitude = currentlocation.coordinate.latitude;
                double longitude = currentlocation.coordinate.longitude;
                NSLog(@"latitude = %f,longitude = %f", latitude, longitude);
                
                KHLocationInfo *locationInfo = [[KHLocationInfo alloc] init];
                locationInfo.countryText = countryText;
                locationInfo.proviceText = proviceText;
                locationInfo.cityText = cityText;
                locationInfo.areaText = areaText;
                
                locationInfo.countryCode = countryCode;
                locationInfo.phone_code = phone_code;
                
                locationInfo.latitude = latitude;
                locationInfo.longitude = longitude;
                
                [self.delegate getLocationWithInfo:locationInfo];
            }
        }];
    }
}

//定位功能开启
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(kCLAuthorizationStatusAuthorizedAlways == status ||
       kCLAuthorizationStatusAuthorizedWhenInUse == status)
    {
        //已经授权,启动定位
        [self.mLocationManager startUpdatingLocation];
    }
    else if (kCLAuthorizationStatusDenied == status)
    {
        //未开启授权
        [_delegate authorizationDeniedorRestricted];
    }
}

#pragma mark - 计算经纬度两点的距离
- (CLLocationDistance)distanceBylatitude:(double)latitude Longitude:(double)longitude latitudeanother:(double)latitudeanother longitudeanother:(double)longitudeanother
{
    CLLocation * currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation * anotherLocation = [[CLLocation alloc] initWithLatitude:latitudeanother longitude:longitudeanother];
    return [currentLocation distanceFromLocation:anotherLocation];
}

@end
