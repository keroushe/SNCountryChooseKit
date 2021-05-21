//
//  UIImage+SNCountryChoose.m
//  SNCountryChooseKit
//
//  Created by hexs on 2021/5/21.
//

#import "UIImage+SNCountryChoose.h"

@implementation UIImage (SNCountryChoose)

+ (UIImage *)sn_imageWithColor:(UIColor *)color {
    return [self sn_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)sn_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
