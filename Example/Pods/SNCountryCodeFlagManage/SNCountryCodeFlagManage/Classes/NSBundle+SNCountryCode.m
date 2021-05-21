//
//  NSBundle+SNCountryCode.m
//  SNCountryCodeFlagManage
//
//  Created by hexs on 2021/5/20.
//

#import "NSBundle+SNCountryCode.h"
#import "SNCountryCodeFlagManage.h"

@implementation NSBundle (SNCountryCode)

+ (instancetype)sn_CountryCodeBundle
{
    static NSBundle *countryCodeBundle = nil;
    if (countryCodeBundle == nil) {
        countryCodeBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[SNCountryCodeFlagManage class]] pathForResource:@"SNCountryCode" ofType:@"bundle"]];
    }
    return countryCodeBundle;
}

@end
