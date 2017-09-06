//
//  ChatTextMessage.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "ChatTextMessage.h"
#import "NSAttributedString+PB.h"
#import "PBChatLabel.h"

#define TextMaxWidth SCREEN_WIDTH-181
static PBChatLabel *chatLabel;

@implementation ChatTextMessage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.msgtype = @(kChatMsgType_Text);
    }
    return self;
}

+ (NSMutableAttributedString *)getTextMessageAttributedStringWithTitle:(NSString *)title
{
    NSMutableAttributedString *attributedMsgString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;//增加行高
    style.firstLineHeadIndent = 0;
    style.headIndent = 4;//头部缩进，相当于左padding
    style.tailIndent = -4;//相当于右padding
    //    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    [attributedMsgString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
    return attributedMsgString;
}

+ (ChatTextMessage *)createTextMessageWithMsg:(ChatMessage *)msg
{
    ChatTextMessage *message = [ChatTextMessage new];
    
    if (chatLabel == nil) {
        chatLabel = [ChatTextMessage getCurrentChatLabel];
    }
    
    NSMutableAttributedString *attributedMsgString = [ChatTextMessage getTextMessageAttributedStringWithTitle:msg.content];
    message.content          = msg.content;

    
    chatLabel.attributedText = attributedMsgString;
    CGSize textSize = [chatLabel sizeThatFits:CGSizeMake(TextMaxWidth, MAXFLOAT)];
    message.attributedMsgString = attributedMsgString;
    message.textWidth = ceilf(textSize.width);
    message.textHeight = ceilf(textSize.height);
    message.renderHeight = ceilf(textSize.height) + 30;
    message.fromuid          = msg.fromuid;
    message.touid            = msg.touid;
    message.otherPartyName   = msg.otherPartyName;
    message.otherPartyAvatar = msg.otherPartyAvatar;
    
    message.rowid            = msg.rowid;
    message.sessionId        = msg.sessionId;
    message.msgStatus        = msg.msgStatus;
    message.msgtype          = msg.msgtype;
    
    message.blobdata         = msg.blobdata;
    message.timesTamp        = msg.timesTamp;
    return message;
}


+ (ChatTextMessage *)createMesgWithRowId:(int)rowId fromUid:(NSNumber *)formUid toUid:(NSNumber *)toUid otherPartyAvatar:(NSString *)avatar
{
    ChatTextMessage *message = [ChatTextMessage new];
    message.timesTamp = @((1501819396 + rowId)*1000);
    int time = rowId%4;
    NSString *title = @"123";
    if (time == 0) {
        title = @"现在的Unix时间戳(Unix timestamp)是：";
    }
    else if (time == 1)
    {
        title = @"如何在不同编程语言中获取现在的Unix时间戳(Unix timestamp)？";
    }
    else if (time == 2)
    {
        title = @"如何在不同编程语言中获取现在的Unix时间戳(Unix timestamp)？";
    }
    else if (time == 3)
    {
        title = @"你好，我们“随播”APP 3.2.1版本不能更换用户头像，这个严重的影响了用户体验，希望能允许我们快速更新。非常感谢！";
    }
    NSMutableAttributedString *attributedMsgString = [ChatTextMessage getTextMessageAttributedStringWithTitle:title];
    if (chatLabel == nil) {
        chatLabel = [ChatTextMessage getCurrentChatLabel];
    }
    chatLabel.attributedText = attributedMsgString;
    CGSize textSize = [chatLabel sizeThatFits:CGSizeMake(TextMaxWidth, MAXFLOAT)];

    message.attributedMsgString = attributedMsgString;
    message.textWidth = ceilf(textSize.width);
    message.textHeight = ceilf(textSize.height);
    message.renderHeight = ceilf(textSize.height) + 30;
    message.fromuid = formUid;
    message.touid = toUid;
    message.otherPartyAvatar = avatar;
    return message;
}

+ (PBChatLabel *)getCurrentChatLabel
{
    PBChatLabel *label = [PBChatLabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    return label;
}


@end
