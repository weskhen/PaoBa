//
//  PBTalkTextView.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBTalkTextView.h"
#import "UIFont+PB.h"
#import "UIColor+PB.h"

@implementation PBTalkTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initValue];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.returnKeyType = UIReturnKeySend;
    self.font = [UIFont fontOfSystemFontWithRegularSize:16];
    self.textColor = [UIColor blackFontColor];
    self.layer.cornerRadius = 4.5;
    self.layer.borderWidth = 1.0/SCREEN_SCALE;
    self.layer.borderColor = [UIColor colorWithHex:0XDCDCDC].CGColor;
}

@end
