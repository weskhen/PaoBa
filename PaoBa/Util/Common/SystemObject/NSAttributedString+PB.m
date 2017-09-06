//
//  NSAttributedString+PB.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "NSAttributedString+PB.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (PB)

- (CGSize)richTextViewSizzeWithWidth:(CGFloat)width
{
    if (self) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
        CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,CGSizeMake(width, CGFLOAT_MAX),NULL);
        if (framesetter){
            CFRelease(framesetter);
        }
        return sz;// 精确Size
    }
    else {
        return CGSizeZero;
    }
}

@end
