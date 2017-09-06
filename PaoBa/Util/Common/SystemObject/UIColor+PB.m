//
//  UIColor+PB.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "UIColor+PB.h"

@implementation UIColor (PB)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

//灰色分隔线
+ (UIColor *)grayLineColor
{
    return [UIColor colorWithHex:0xc8c8cc];
}

+ (UIColor *)grayFontColor
{
    return [UIColor colorWithHex:0x999999];
}

//黑色字体
+ (UIColor *)blackFontColor
{
    return [UIColor colorWithHex:0x000000];
}

+ (UIColor *)hexChangeFloat:(NSString *)hexColor {
    if (hexColor.length < 6) {
        NSLog(@"error HexColor!!");
        return nil;
    }
    unsigned int redInt_, greenInt_, blueInt_;
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;  // 范围长度为2
    // 取红色的值
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&redInt_];
    // 取绿色的值
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&greenInt_];
    // 取蓝色的值
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
     scanHexInt:&blueInt_];
    return [UIColor colorWithRed:(float)(redInt_/255.0f)
                           green:(float)(greenInt_/255.0f)
                            blue:(float)(blueInt_/255.0f)
                           alpha:1.0f];
}

@end
