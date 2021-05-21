//
//  SNCountryChooseLanHandle.m
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import "SNCountryChooseLanHandle.h"

@implementation SNCountryChooseLanHandle

+ (SNCountryChooseLanHandle *)sharedInstance
{
    static SNCountryChooseLanHandle *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[SNCountryChooseLanHandle alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _curLan = @"en";
        _keyNewCityChoose_Title = @"Location";
        _keyNewCityChoose_UseCur_Location = @"Use current location";
        _keyNewCityChoose_Locationing = @"Positioning...";
        _keyNewCityChoose_Location_Disable = @"The current location is not available";
    }
    return self;
}

@end
