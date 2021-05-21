//
//  NSBundle+SNCountryChoose.m
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import "NSBundle+SNCountryChoose.h"
#import "SNCountryChooseBaseVC.h"

@implementation NSBundle (SNCountryChoose)

+ (instancetype)sn_countryChooseBundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[SNCountryChooseBaseVC class]] pathForResource:@"SNCountryChooseKit" ofType:@"bundle"]];
    }
    return bundle;
}

@end
