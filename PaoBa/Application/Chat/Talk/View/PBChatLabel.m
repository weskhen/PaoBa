//
//  PBChatLabel.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBChatLabel.h"
#import <CoreText/CoreText.h>

@interface PBChatLabel ()

@property (nonatomic, assign) CTFrameRef ctFrame;

@property (nonatomic, assign) CGFloat lineSpace;
@end
@implementation PBChatLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initValue];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue
{
    //初始化数据
    self.font = [UIFont systemFontOfSize:13];
    self.backgroundColor = [UIColor clearColor];
}

- (CTFrameRef)ctFrame
{
    if (_ctFrame == nil) {
        if (self.attributedText)
        {
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
            CFRange rgzero = CFRangeMake(0, 0);
            CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), 0);
            _ctFrame = CTFramesetterCreateFrame(framesetter, rgzero, path, 0);
            CGPathRelease(path);
            CFRelease(framesetter);
        }
    }
    return _ctFrame;
}


#pragma mark -样式及手势

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([_delegate respondsToSelector:@selector(hasTouchPBChatLabelWillContinue)]) {
        [_delegate hasTouchPBChatLabelWillContinue];
    }
}


//String touch 处理
- (void)handleTouchPBChatLabel:(NSInteger)index touch:(UITouch *)touch
{
    NSString *phoneNumber = [self getPhoneNumberAtTouch:index];
    if (phoneNumber) {
        if ([_delegate respondsToSelector:@selector(phoneNumberTouch:)]) {
            [_delegate phoneNumberTouch:phoneNumber];
        }
        return;
    }
    NSURL *url = [self getURLAtTouch:index];
    if (url) {
        if ([_delegate respondsToSelector:@selector(urlStringTouch:)]) {
            [_delegate urlStringTouch:url];
        }
        return;
    }
}

- (NSString *)getPhoneNumberAtTouch:(NSInteger)index
{
    NSUInteger indexL = index - 1, indexR = index + 1; // A|B, idx in the middle so we give both A and B a chance to go
    
    NSString *str = [self.attributedText string];
    NSError* error = nil;
    __block NSString *found = nil;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    [linkDetector enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange r = [result range];
        if (NSLocationInRange(indexL, r) || NSLocationInRange(indexR, r)) {
            found = [result phoneNumber];
            *stop = YES;
        }
    }];
    return found;
}

- (NSURL*)getURLAtTouch:(NSInteger)index
{
    NSUInteger indexL = index - 1, indexR = index + 1; // A|B, idx in the middle so we give both A and B a chance to go
    NSString *str = [self.attributedText string];
    NSError *error = nil;
    __block NSURL *found = nil;
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    [linkDetector enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString* matchedStr = [[[result URL] scheme] lowercaseString];
        if ([matchedStr isEqualToString:@"http"] || [matchedStr isEqualToString:@"https"]) {
            NSRange r = [result range];
            if (NSLocationInRange(indexL, r) || NSLocationInRange(indexR, r)) {
                found = [result URL];
                *stop = YES;
            }
        }
    }];
    return found;
}


@end
