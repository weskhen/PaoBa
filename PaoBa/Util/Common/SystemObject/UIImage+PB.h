//
//  UIImage+PB.h
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PB)

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size;

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius;

- (UIImage*)iconAvatarImageWithWidth:(double)width cornerRadius:(double)radius;

/*
 方向矫正
 1.先将头朝上
 2.将镜象反转
 3.重新合成图片
 
 */

+ (UIImage*)fixOrientation:(UIImage*)aImage;

@end
