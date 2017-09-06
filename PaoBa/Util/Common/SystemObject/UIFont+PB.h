//
//  UIFont+PB.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (PB)

+ (UIFont*)appFontOfSize:(CGFloat)size;
+ (UIFont*)boldAppFontOfSize:(CGFloat)size;
+ (UIFont *)fontOfHelveticaNeueLightWithSize:(CGFloat)size;
+ (UIFont *)fontOfHelveticaNeueRegularWithSize:(CGFloat)size;
+ (UIFont *)fontOfHelveticaNeueThinWithSize:(CGFloat)size;
+ (UIFont *)fontOfRobotoRegularWithSize:(CGFloat)size;
+ (UIFont *)fontOfHelveticaNeueMediumWithSize:(CGFloat)size;

+ (UIFont *)fontOfSystemFontWithMediumSize:(CGFloat)size;
+ (UIFont *)fontOfSystemFontWithSemiBoldSize:(CGFloat)size;
+ (UIFont *)fontOfSystemFontWithRegularSize:(CGFloat)size;
+ (UIFont *)fontOfSystemFontWithHeavySize:(CGFloat)size;

@end
