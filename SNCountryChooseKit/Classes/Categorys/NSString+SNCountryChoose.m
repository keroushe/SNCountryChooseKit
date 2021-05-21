//
//  NSString+SNCountryChoose.m
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import "NSString+SNCountryChoose.h"

@implementation NSString (SNCountryChoose)

/**
 传入字符串,返回大写的首字母
 */
+ (NSString *)sn_getFirstLetter:(NSString *)strInput
{
    NSInteger length = 0;
    NSInteger location = 0;
    if (strInput.length > 0)
    {
        location = 0;
        length = 1;
    }
    else
    {
        return @"";
    }
    
    NSRange range = NSMakeRange(location, length);
    NSString *nameString = [strInput substringWithRange:range];
    if ([nameString length])
    {
        if (([nameString hasPrefix:@" "]) && ([nameString hasSuffix:@" "]))
        {
            nameString = [nameString stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:nameString];
        if (ms.length < 1) {
            return @"";
        }
        
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        NSString *letterString = @"";
        NSArray *pyArray = [ms componentsSeparatedByString:@" "];
        if(pyArray && pyArray.count > 0)
        {
            letterString = [pyArray.firstObject substringToIndex:1];
            return [letterString uppercaseString];
        }
        return @"";
    }
    return @"";
}

/**
 判断字符是否是只有字母组成
 */
- (BOOL)sn_isOnlyLatter
{
    if (self.length == 0)
    {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.length; i++)
    {
        unichar ch = [self characterAtIndex:i];
        if (!(((ch >= 'a') && (ch <= 'z')) || ((ch >= 'A') && (ch <= 'Z'))) || (ch == ' ')){ //0=48
            return NO;
        }
    }
    return YES;
}

/**
 *  通过传入的字符串数组,返回排好序的新的字符串数组
 *  state:0:升序   1:降序
 */
+ (NSArray *)sn_sortStringFromArray:(NSArray *)stringArray upOrDown:(int)state
{
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2) {
        
        NSRange range = NSMakeRange(0,obj1.length);
        if (state == 0)
        {
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        }
        else
        {
            return [obj2 compare:obj1 options:comparisonOptions range:range];
        }
    };
    return [stringArray sortedArrayUsingComparator:sort];
}

@end
