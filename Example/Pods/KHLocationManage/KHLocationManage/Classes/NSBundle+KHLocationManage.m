//
//  NSBundle+KHLocationManage.m
//  KHLocationManage
//
//  Created by hexs on 2021/5/21.
//

#import "NSBundle+KHLocationManage.h"
#import "KHLocationManage.h"

@implementation NSBundle (KHLocationManage)

+ (instancetype)kh_locationManageBundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[KHLocationManage class]] pathForResource:@"KHLocationManage" ofType:@"bundle"]];
    }
    return bundle;
}

@end
