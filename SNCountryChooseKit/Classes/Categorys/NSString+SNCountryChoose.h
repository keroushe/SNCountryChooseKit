//
//  NSString+SNCountryChoose.h
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SNCountryChoose)

/**
 传入字符串,返回大写的首字母
 */
+ (NSString *)sn_getFirstLetter:(NSString *)strInput;

/**
 判断字符是否是只有字母组成
 */
- (BOOL)sn_isOnlyLatter;

/**
 *  通过传入的字符串数组,返回排好序的新的字符串数组
 *  state:0:升序   1:降序
 */
+ (NSArray *)sn_sortStringFromArray:(NSArray *)stringArray upOrDown:(int)state;

@end

NS_ASSUME_NONNULL_END
