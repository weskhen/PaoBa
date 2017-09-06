//
//  UIColor+PB.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PB)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*)colorWithHex:(NSInteger)hexValue;

//灰色分隔线
+ (UIColor *)grayLineColor;
+ (UIColor *)grayFontColor;

//黑色字体
+ (UIColor *)blackFontColor;


// 将十六进制颜色的字符串转化为复合iphone/ipad的颜色
// 字符串为"FFFFFF"
+ (UIColor *)hexChangeFloat:(NSString *) hexColor;

@end
