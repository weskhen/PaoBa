//
//  ChatGiftMessage.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatGiftMessage.h"
#import "UIColor+PB.h"
#import "NSAttributedString+PB.h"

@implementation ChatGiftMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.msgtype = @(kChatMsgType_Gift);
    }
    return self;
}

- (NSAttributedString *)titleString
{
    if (!_titleString) {
        return _titleString;
    }
    return [self getCurrentTitleString];
}

- (CGFloat)titleHeight
{
    if (_titleHeight < 1) {
        _titleHeight = [self.titleString richTextViewSizzeWithWidth:128].height;
    }
    return _titleHeight;
}

- (NSAttributedString *)getCurrentTitleString
{
    NSString *title = [NSString stringWithFormat:@"我送出了%@个%@",self.giftNumber,self.giftName];
    NSDictionary *attrDict =@{
                              NSFontAttributeName:[UIFont systemFontOfSize:13],//字体大小
                              };

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:attrDict];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHex:0xFF5849]
                             range:NSMakeRange(4, [self.giftNumber stringValue].length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHex:0xFF5849]
                             range:NSMakeRange(title.length-self.giftName.length, [self.giftNumber stringValue].length)];
    return attributedString;
}


@end
