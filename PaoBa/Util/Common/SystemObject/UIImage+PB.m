//
//  UIImage+PB.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "UIImage+PB.h"

@implementation UIImage (PB)


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}

+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//生成圆角UIImage 的方法
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius
{
    UIImage *original = self;
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)iconAvatarImageWithWidth:(double)width cornerRadius:(double)radius
{
    float border = 0.0f;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    width = width*scale;\
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//1
    CGContextRef context = CGBitmapContextCreate(nil, width, width,
                                                 8, 0, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);//2
    
    CGSize imgSize = self.size;
    CGFloat mid = width/2;
    
    
    if (radius > 0.0f)
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, mid);
        CGContextAddArcToPoint(context, 0, 0, mid, 0, radius);
        CGContextAddArcToPoint(context, width, 0, width, mid, radius);
        CGContextAddArcToPoint(context, width, width, mid, width, radius);
        CGContextAddArcToPoint(context, 0, width, 0, mid, radius);
        CGContextClosePath(context);                                              //4
        CGContextClip(context);
    }
    
    // draw image
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    if(imgSize.width>=imgSize.height){
        double rate = imgSize.width/imgSize.height;
        
        CGContextDrawImage(context, CGRectMake(floor(-(rate-1)/2*width)+border, border, floor(rate*width)-2*border, floor(width)-2*border), self.CGImage);
    }
    else{
        double rate = imgSize.height/imgSize.width;
        
        CGContextDrawImage(context, CGRectMake(0+border, floor(-(rate-1)/2*width)+border, floor(width)-2*border, floor(rate*width)-2*border), self.CGImage);
    }
    
    //    // draw border，border画在image上面
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:0xa6a6a6].CGColor);                  //6
    //    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    //
    //    CGContextBeginPath(context);
    //    // 起点origin，中间点mid，边距borderBorder
    //    // 边框圆与image圆是同心圆，边框圆的半径比image圆小0.5
    //    CGFloat origin = 0.5;
    //    CGFloat borderBorder = width - origin;
    //    CGContextMoveToPoint(context, origin, mid);
    //    CGContextAddArcToPoint(context, origin, origin, mid, origin, radius);
    //    CGContextAddArcToPoint(context, borderBorder, origin, borderBorder, mid, radius);
    //    CGContextAddArcToPoint(context, borderBorder, borderBorder, mid, borderBorder, radius);
    //    CGContextAddArcToPoint(context, origin, borderBorder, origin, mid, radius);
    //    CGContextClosePath(context);
    //    CGContextSetLineWidth(context, 0.5);
    //    CGContextDrawPath(context,kCGPathStroke);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    if(cgimg) CGImageRelease(cgimg);
    if(context) CGContextRelease (context);
    if(colorSpace) CGColorSpaceRelease(colorSpace);
    
    return img;
}

/*
 方向矫正
 1.先将头朝上
 2.将镜象反转
 3.重新合成图片
 
 */

+ (UIImage*)fixOrientation:(UIImage*)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
