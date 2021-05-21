//
//  SNCountryChooseLanHandle.h
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCountryChooseLanHandle : NSObject

@property (class, strong, readonly) SNCountryChooseLanHandle *sharedInstance;

@property (nonatomic, copy) NSString *curLan;
@property (nonatomic, copy) NSString *keyNewCityChoose_Title;
@property (nonatomic, copy) NSString *keyNewCityChoose_UseCur_Location;
@property (nonatomic, copy) NSString *keyNewCityChoose_Locationing;
@property (nonatomic, copy) NSString *keyNewCityChoose_Location_Disable;

@end

NS_ASSUME_NONNULL_END
